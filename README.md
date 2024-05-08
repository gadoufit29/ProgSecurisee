# ProgSecurisee

## Clone du projet

`git clone https://github.com/gadoufit29/ProgSecurisee`

## Installation des dépendances

Pour ce faire il vous faudra l'outil **pip** 

Étapes d'installation :

1. Se rendre dans la racine du projet (dans le dossier ProgSecurisee) via votre terminal
2. Exécutez la commande : `pip install -r requirements.txt`
3. Entrez ensuite : `source venv/bin/activate` 

Et voila, les dépendances sont installés !

## Lancement de votre serveur web

Dans cette partie je prendrais comme exemple xampp

1. Ouvrez XAMPP
2. Aller dans l'onglet **Manage Servers**
3. Démarrez les services : **MySQL Database** et **Apache Web Server**

<img width="658" alt="SCR-20240508-svzi" src="https://github.com/gadoufit29/ProgSecurisee/assets/76166929/8e90308b-5166-4206-b560-97c3ecb28503">

## Création de la base de données et des tables

### Création de la base de données

1. Rendez vous à l'adresse : *localhost/phpmyadmin*
2. Cliquez sur : Nouvelle base de données

<img width="193" alt="SCR-20240508-tcda" src="https://github.com/gadoufit29/ProgSecurisee/assets/76166929/2156f4e2-e711-426a-b023-b68ee0351fda">

3. Dans le champ *Nom* mettez : **flaskapp**

<img width="521" alt="SCR-20240508-tcjt" src="https://github.com/gadoufit29/ProgSecurisee/assets/76166929/07668699-af3b-47a4-8831-5b9bb4eb97d6">

4. Cliquez sur **Créer**

Votre base de données est désormais créée 

### Création de la table

1. Allez dans la base de données que vous venez de créer (flaskapp)
2. Dans le menu du haut, cliquez sur **Importer**

<img width="1233" alt="SCR-20240508-tdec" src="https://github.com/gadoufit29/ProgSecurisee/assets/76166929/888e297b-7291-4ebf-803d-5ccbee68de24">

3. Puis sur **Choisir le fichier**

<img width="567" alt="SCR-20240508-tdnk" src="https://github.com/gadoufit29/ProgSecurisee/assets/76166929/8cdce5ce-7b1a-414c-add2-a2bc479013ec">

4. Sélectionner le fichier *boutiqueproject.sql* situé dans la racine du projet *ProgSecurisee*

<img width="264" alt="SCR-20240508-tejo" src="https://github.com/gadoufit29/ProgSecurisee/assets/76166929/74671ffe-b349-4dd3-9f7b-8f2b8be09f9e">

5. Descendez tout en bas et cliquez sur **Importer**

Félicitations ! Votre base de données contient désormais toutes les tables nécessaires au bon fonctionnement du site !

## Variables d'envrionnement

Dernière étape avant de lancer le projet, il faut définir vos variables d'envrionnement.

Si vous posséder déja mysql sur votre pc, vos variables d'environnement seront trouvées automatiquement, vous pouvez donc passer cette partie. 

Sinon il vous faut installer le module **mysqlclient**

Une fois cela fait, rendez-vous dans votre fichier de configuration (sur mac ce sera ~/.zshrc), aller à la fin du fichier et rajoutez :

```
export MYSQL_USER=root
export MYSQL_PASSWORD=
```

Ces identifiants sont ceux par défaut de MySQL

Entrez ensuite la commande `source ~/.zshrc`


## Lancement du site 

1. Toujours via votre terminal, dans la racine du projet entrez `flask run`
2. Copier le lien que flask vous a donné (http://127.0.0.1:5000/) dans votre navigateur

<img width="1456" alt="image" src="https://github.com/gadoufit29/ProgSecurisee/assets/76166929/639f8621-55e9-4c16-9664-e4b3a61db23d">

Vous avez désormais accès au site et à toutes les fonctionnalités dont il dispose !

> [!CAUTION]
> Vous pouvez vous créer un compte, vous serait simple utilisateur
> Si vous souhaitez être admin, voici votre pair
> *username:password* --> **B3stadmin:Strong3stPassw0rd**






