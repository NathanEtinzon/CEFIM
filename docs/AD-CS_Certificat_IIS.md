# AD-CS Certificat IIS

**/!\ Remplacer les différentes informations par les votres /!\\**

## 1ère étape : Génération de la requête de certificat
***Sur le serveur IIS***

Dans la console de gestion de IIS, ouvrir la console *Certificat*, faire un clic-droit et sélectionner *Créer une demande de certificat*
<img src= "https://imgur.com/tXb2ly6.jpg">

Renseigner les informations suivantes.
<img src= "https://imgur.com/jMyZmkB.jpg">

Sélectionner le paramétrage ci-dessous.
<img src= "https://imgur.com/3Lj0A4r.jpg">

Renseigner le dossier et de nom où se trouvera la requête.
<img src= "https://imgur.com/CkR0jjz.jpg">
<img src= "https://imgur.com/BXhgsjF.jpg">


## 2ème étape : Récupération de la requête
***Sur le serveur AD-CS***  
***Via Partage réseau / Winscp / VMtools***

## 3ème étape : Création du certificat
***Sur le serveur AD-CS***

Sur PowerShell, entrer les commandes suivantes :  
certutil -setreg policy\EditFlags +EDITF_ATTRIBUTESUBJECTALTNAME2  
/!\ Rédemarrer le service sinon les modifications ne seront pas prises en compte /!\  

Ensuite :  
<img src= "https://imgur.com/co9XlnX.jpg">
certreq -submit -attrib "CertificateTemplate:webServer\nSAN:dns=Ton_FQDN&ipaddress=IP_IIS" Requête.txt

Sélectionner l'autorité de certification.
<img src= "https://imgur.com/PJgHLo1.jpg">

Enregistrer le certificat en .cer
<img src= "https://imgur.com/yHm2L91.jpg">

## 4ème étape : Récupération du certificat
***Sur le serveur IIS***  
***Partage réseau / Winscp / VMtools***

## 5ème étape : Importation du certificat
***Sur le serveur IIS***

Dans la console de gestion de IIS, ouvrir la console *Certificat*, faite un clic-droit et sélectionner *Terminer une demande de certificat*.
<img src= "https://imgur.com/lzvLCvU.jpg">

Sélectionner le certificat.
<img src= "https://imgur.com/fCH97Wg.jpg">

## 6ème étape : Débugage certificat fantôme
***Sur le serveur IIS***  
(Si le certificat disparait dès que la console est actualisée, suivez les étapes suivantes)

Dans la console de certificat, dans le magasin *Hébergement Web*, rechercher le numéro de série de votre certificat et le copier.
<img src= "https://imgur.com/fFOCRCA.jpg">

Sous PowerShell, entrer la commande suivante :  
certutil -repairstore webHosting Serial_Number

Résultat :  
<img src= "https://imgur.com/yrSOoAd.jpg">

Rafraichir la console IIS et le certificat devrait réapparaître.

## 7ème étape : Liaison HTTPS
***Sur le serveur IIS***

Dans la console de gestion de IIS, faire un clic-droit sur le VHost et sélectionner *Modifier les liaisons*.
<img src= "https://imgur.com/9nANl5W.jpg">

Créer la liaison suivante en sélectionnant le certificat récemment importé.
<img src= "https://imgur.com/jC0dYES.jpg">

## 8ème étape : Redirection HTTP => HTTPS

Superbe procédure :
https://www.ssl.com/how-to/redirect-http-to-https-with-windows-iis-10/

***

## Résultat

<img src= "https://imgur.com/HzpEvLy.jpg">