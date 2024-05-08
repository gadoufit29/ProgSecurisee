from flask import Flask, render_template, request, redirect, url_for, session
from models import *
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
import json
from datetime import datetime
import random
import secrets
import string
import hashlib
import math
import pyqrcode
from flask_wtf.csrf import CSRFProtect, validate_csrf
from io import BytesIO

user = os.environ['MYSQL_USER']
password = os.environ['MYSQL_PASSWORD']

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql://{user}:{password}@127.0.0.1:3306/flaskapp"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = base64.b32encode(os.urandom(25)).decode('utf-8')
csrf = CSRFProtect()
csrf.init_app(app)
db.init_app(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'
login_page = 'login.html'
index_page = 'index.html'
assets_location = 'static/assets/'

signatures = []

@login_manager.user_loader
def load_user(user_id):
    return Users.query.get(int(user_id))

@app.context_processor
def add_global_var():
    categories = Categories.query.all()
    categories_dict = {}
    categories_dict[0] = 'Aucune'
    for category in categories:
        categories_dict[category.id] = category.name
    return dict(CATEGORIES=categories, CATEGORIES_DICT=categories_dict)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = hashlib.sha256(request.form['password'].encode()).hexdigest()
        user = Users.query.filter_by(name=username).first()

        if user is None:
            return render_template(login_page, error_no_account=True, attemps=0)

        if user.last_attemp is not None:
            print(datetime.now())
            print(user.last_attemp)
            delta_time = datetime.now() - user.last_attemp
            time_remaining = int(math.exp(user.locked_counter)) - int(delta_time.seconds / 60)
            print(time_remaining)
            if time_remaining > 0:
                return render_template(login_page, error=True, attemps=0, time_remaining=time_remaining, locked=True)

        if user.check_password(password):
            user.attemp_counter = 0
            user.last_attemp = None
            user.locked_counter = 0
            db.session.commit()

            if user.totp_secret is not None:
                signature = base64.b32encode(os.urandom(10)).decode('utf-8')
                signatures.append(signature)
                session['signature'] = signature
                return redirect(url_for('totp', username=user.name))

            login_user(user)
            return redirect(url_for('index'))
        else:
            user.attemp_counter += 1
            if user.attemp_counter == 3:
                user.attemp_counter = 0
                user.locked_counter += 1
                user.last_attemp = datetime.now()
                db.session.commit()
                return render_template(login_page, error=True, attemps=0, time_remaining=int(math.exp(user.locked_counter)) - int((datetime.now() - user.last_attemp).seconds / 60), locked=True)
            db.session.commit()
            return render_template(login_page, error=True, attemps=3-user.attemp_counter)
    return render_template(login_page)

@app.route('/totp/<username>', methods=['GET', 'POST'])
def totp(username):
    if 'signature' not in session:
        return redirect(url_for('login'))
    elif session['signature'] not in signatures:
        return redirect(url_for('login'))
    else:
        if request.method == 'POST':
            user = Users.query.filter_by(name=username).first()
            token = request.form['token']
            if user.verify_totp(token):
                print("success")
                signatures.remove(session['signature'])
                del session['signature']
                login_user(user)
                return redirect(url_for('index'))
            else:
                print("error")
                return render_template('totp.html', error=True, username=username)
        return render_template('totp.html', username=username)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/')
def index():
    all_products = Products.query.all()
    return render_template(index_page, all_products=all_products, id=0)

@app.route('/category/<int:id>')
def category(id):
    all_products = Products.query.filter_by(category_id=id).all()
    return render_template(index_page, all_products=all_products, id=id)

@app.route('/product/<int:id>')
def product(id):
    product = Products.query.get(id)
    if product is None:
        return redirect(url_for('index'))
    comments = Comments.query.filter_by(product_id=id).all()
    for comment in comments:
        user = Users.query.get(comment.user_id)
        comment.user_name = user.name
    supp_pics = json.loads(product.supp_pic)
    return render_template('product.html', product=product, supp_pic=supp_pics, comments=comments)

@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == 'POST':
        search = request.form['search']
        products = Products.query.filter(Products.name.like('%'+search+'%')).all()
        products_by_desc = Products.query.filter(Products.description.like('%'+search+'%')).all()

        for prod in products_by_desc:
            if prod not in products:
                products.append(prod)

        return render_template(index_page, all_products=products, id=-1)
    else:
        return redirect(url_for('index'))

@app.route('/account')
@login_required
def account():
    orders = Orders.query.filter_by(user_id=current_user.id).all()
    return render_template('account.html', orders=orders)

@app.route('/add_comment/<int:product_id>', methods=['POST'])
@login_required
def add_comment(product_id):
    content = request.form['content']
    comment = Comments(content=content, user_id=current_user.id, product_id=product_id)
    db.session.add(comment)
    db.session.commit()
    return redirect(url_for('product', id=product_id))

@app.route('/cart')
@login_required
def cart():
    user = Users.query.get(current_user.id)
    cart = json.loads(user.cart)
    wishlist = json.loads(user.wishlist)
    products = []
    products_wishlist = []
    total = 0
    for product_id in cart:
        product = Products.query.get(product_id)
        if product is not None:
            products.append(product)
            total += product.price

    for product_id in wishlist:
        product = Products.query.get(product_id)
        if product is not None:
            products_wishlist.append(product)

    return render_template('cart.html', products=products, total=str(round(total, 2)), products_wishlist=products_wishlist)

@app.route('/add_to_cart/<int:product_id>')
@login_required
def add_to_cart(product_id):
    user = Users.query.get(current_user.id)
    cart = json.loads(user.cart)
    print(cart)
    print(type(cart))
    cart.append(product_id)
    user.cart = json.dumps(cart)
    db.session.commit()

    product = Products.query.get(product_id)
    if product is None:
        return redirect(url_for('index'))
    comments = Comments.query.filter_by(product_id=id).all()
    for comment in comments:
        user = Users.query.get(comment.user_id)
        comment.user_name = user.name
    supp_pics = json.loads(product.supp_pic)
    return render_template('product.html', product=product, supp_pic=supp_pics, comments=comments, success=True)

@app.route('/remove_from_cart/<int:product_id>')
@login_required
def remove_from_cart(product_id):
    user = Users.query.get(current_user.id)
    cart = json.loads(user.cart)
    cart.remove(product_id)
    user.cart = json.dumps(cart)
    db.session.commit()
    return redirect(url_for('cart'))

@app.route('/add_to_wl/<int:product_id>')
@login_required
def add_to_wl(product_id):
    user = Users.query.get(current_user.id)
    wishlist = json.loads(user.wishlist)
    wishlist.append(product_id)
    user.wishlist = json.dumps(wishlist)
    db.session.commit()
    return redirect(url_for('cart'))

@app.route('/remove_from_wl/<int:product_id>')
@login_required
def remove_from_wl(product_id):
    user = Users.query.get(current_user.id)
    wishlist = json.loads(user.wishlist)
    wishlist.remove(product_id)
    user.wishlist = json.dumps(wishlist)
    db.session.commit()
    return redirect(url_for('cart'))

@app.route('/buy')
@login_required
def buy():
    user = Users.query.get(current_user.id)
    cart = json.loads(user.cart)
    price = 0
    for product_id in cart:
        product = Products.query.get(product_id)
        if product is not None:
            price += product.price
    order = Orders(user_id=current_user.id, price=price, status='pending', date=datetime.now())
    db.session.add(order)
    db.session.commit()
    user.cart = json.dumps([])
    db.session.commit()
    return redirect(url_for('account'))

@app.route('/register' , methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['username']
        password = hashlib.sha256(request.form['password'].encode()).hexdigest()
        mail = request.form['mail']
        user = Users(name=name, password=password, mail=mail, admin=0, cart=json.dumps([]), wishlist=json.dumps([]))

        existing_user = Users.query.filter_by(name=name).first()
        if existing_user:
            return render_template('register.html', error_existing=True)

        db.session.add(user)
        db.session.commit()
        return redirect(url_for('login'))
    return render_template('register.html')


@app.route('/backoffice')
@login_required
def backoffice():
    if current_user.admin == 1:
        products = Products.query.all()
        return render_template('backoffice.html', products=products)
    else:
        return redirect(url_for('index'))

@app.route('/modify_product/<int:id>', methods=['POST'])
@login_required
def modify_product(id):
    if current_user.admin == 1:
        product = Products.query.get(id)

        if ',' in request.form['price']:
            price = request.form['price'].replace(',', '.')
        else:
            price = request.form['price']


        product.name = request.form['name']
        product.price = price
        product.description = request.form['description']
        product.qte = request.form['qte']
        product.category_id = request.form['category']

        if 'pic' in request.files and request.files['pic'].filename != '':
            pic = request.files.getlist('pic')
            extension = pic[0].filename.split('.')[-1]
            pic[0].filename = str(''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(6)))+'.'+extension
            pic[0].save(assets_location+pic[0].filename)
            product.pic = pic[0].filename

            if len(pic) > 1:
                supp_pics = []
                for i in range(1, len(pic)):
                    extension = pic[i].filename.split('.')[-1]
                    pic[i].filename = str(''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(6)))+'.'+extension
                    pic[i].save(assets_location+pic[i].filename)
                    supp_pics.append(pic[i].filename)
                product.supp_pic = json.dumps(supp_pics)

        db.session.commit()
        return redirect(url_for('backoffice'))
    else:
        return redirect(url_for('index'))

@app.route('/delete_product/<int:id>')
@login_required
def delete_product(id):
    if current_user.admin == 1:
        product = Products.query.get(id)
        comments = Comments.query.filter_by(product_id=id).all()
        for comment in comments:
            db.session.delete(comment)
        db.session.commit()
        db.session.delete(product)
        db.session.commit()
        return redirect(url_for('backoffice'))

@app.route('/add_product', methods=['POST'])
@login_required
def add_product():
    if current_user.admin == 1:
        name = request.form['name']
        price = request.form['price']
        description = request.form['description']
        qte = request.form['qte']
        pic = request.files.getlist("pic")
        category_id = request.form['category']
        extension = pic[0].filename.split('.')[-1]
        pic[0].filename = str(''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(6))) + '.' + extension
        pic[0].save(assets_location+pic[0].filename)
        product = Products(name=name, price=price, description=description, qte=qte, pic=pic[0].filename, category_id=category_id)

        if len(pic) > 1:
            supp_pics = []
            for i in range(1, len(pic)):
                extension = pic[i].filename.split('.')[-1]
                pic[i].filename = str(''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(6)))+'.'+extension
                pic[i].save(assets_location+pic[i].filename)
                supp_pics.append(pic[i].filename)
            product.supp_pic = json.dumps(supp_pics)

        db.session.add(product)
        db.session.commit()
        return redirect(url_for('backoffice'))
    else:
        return redirect(url_for('index'))

@app.route('/delete_comment/<int:id>')
@login_required
def delete_comment(id):
    comment = Comments.query.get(id)
    if comment is None:
        return redirect(url_for('index'))
    if (current_user.admin != 1) and (comment.user_id != current_user.id):
        return "You do not have the permissions to delete this comment."
    db.session.delete(comment)
    db.session.commit()
    return redirect(url_for('product', id=comment.product_id))

@app.route('/modify_comment/<int:id>', methods=['POST'])
@csrf.exempt
@login_required
def modify_comment(id):
    comment = Comments.query.get(id)
    if comment is None:
        print("comment is None")
    if (current_user.admin != 1) and (comment.user_id != current_user.id):
        return "You do not have the permissions to modify this comment."
    comment.content = request.get_json().get('comment')
    db.session.commit()
    return redirect(url_for('product', id=comment.product_id))

@app.route('/qr_code')
@login_required
def qr_code():
    username = current_user.name
    user = Users.query.filter_by(name=username).first()
    if user is None:
        return(redirect(url_for('login')))

    url = pyqrcode.create(user.get_totp_uri())
    stream = BytesIO()
    url.svg(stream, scale=5)
    return stream.getvalue(), 200, {
        'Content-Type': 'image/svg+xml',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0'}

@app.route('/add_totp')
@login_required
def add_totp():
    username = current_user.name
    user = Users.query.filter_by(name=username).first()
    if user is None:
        return redirect(url_for('login'))

    print(user.totp_secret)

    if user.totp_secret is None:
        user.totp_secret = base64.b32encode(os.urandom(10)).decode('utf-8')
        db.session.commit()
        return render_template('add_totp.html')
    else:
        return "TOTP already enabled"

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

if __name__ == '__main__':
    app.run(debug=False)