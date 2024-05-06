import os
import onetimepass as otp
import base64
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Products(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    price = db.Column(db.Float)
    description = db.Column(db.String(500))
    pic = db.Column(db.String(100))
    supp_pic = db.Column(db.JSON)
    qte = db.Column(db.Integer)
    category_id = db.Column(db.Integer)

class Users(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    password = db.Column(db.String(100))
    mail = db.Column(db.String(100))
    admin = db.Column(db.Integer)
    cart = db.Column(db.JSON)
    wishlist = db.Column(db.JSON)
    attemp_counter = db.Column(db.Integer)
    last_attemp = db.Column(db.DateTime)
    locked_counter = db.Column(db.Integer)
    totp_secret = db.Column(db.String)
    reset_password = db.Column(db.String)

    def get_totp_uri(self):
        return f'otpauth://totp/boutique:{self.name}?secret={self.totp_secret}&issuer=boutique'

    def verify_totp(self, token):
        return otp.valid_totp(token, self.totp_secret)

    def check_password(self, password):
        if self.password == password:
            return True
        else:
            return False

    def is_authenticated(self):
        return True

    def is_active(self):   
        return True           

    def is_anonymous(self):
        return False          

    def get_id(self):         
        return str(self.id)

class Comments(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(500))
    user_id = db.Column(db.Integer)
    product_id = db.Column(db.Integer)


class Orders(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)
    date = db.Column(db.Date)
    status = db.Column(db.String(100))
    price = db.Column(db.Float)
    
class Categories(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))