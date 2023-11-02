# AD-CS Certificat apache

## 1ère étape : Génération du clé avec openssl

***Création de la clé***

cd /etc/ssl/private  
sudo openssl genrsa -out www.etinzon.cefim.key 2048

***

## 2ème étape : Création d'un fichier de conf avec les subjectAltName

***Création du fichier de conf avec les SubjectAltName***

cd /etc/ssl  
nano www.etinzon.cefim.conf

[req]  
default_bits = 2048  
prompt = no  
default_md = sha256  
req_extensions = req_ext  
distinguished_name = dn  
[ dn ]  
C=FR  
ST=Tours  
L=CVDL  
O=IT 
OU=Testing Domain  
emailAddress=admin@www.etinzon.cefim  
CN = www.etinzon.cefim  
[ req_ext ]  
subjectAltName = @alt_names  
[ alt_names ]  
DNS.1 = etinzon.cefim  
DNS.2 = www.etinzon.cefim  

***

## 3ème étape : Création du csr avec le fichier de conf

***On se place à l'endroit où est la clé, on indique que l'on veut un certificat csr avec comme config le fichier de conf crée auparavant***

cd /etc/ssl/private 
openssl req -new -key www.etinzon.cefim.key -out www.etinzon.cefim.csr -config ../www.etinzon.cefim.conf

***

## 4ème étape : Importer le csr sur l'AD-CS

***Partage réseau / Winscp / VMtools***

***

## 5ème étape : Signer le csr avec l'authorité de certification

***Se déplacer dans l'emplacement où a été deposé le .csr, ensuite lancer une requête afin de signer le certificat et obtenir un .cer***

cd ./desktop  
certreq -submit -attrib "CertificateTemplate:WebServer" www.etinzon.cefim.csr

<img src= "https://imgur.com/MGtKV3t.jpg">

Ensuite, donner un nom au fichier.  
*Exemple : www.etinzon.cefim*

<img src= "https://imgur.com/lRnewV5.jpg">

***

## 6ème étape : Importer le .cer dans l'apache 

***Partage réseau / Winscp / VMtools***

Deposer le .cer dans /etc/ssl/cert

<img src= "https://imgur.com/ncWLkYP.jpg">

***

## 7ème étape : Configuration d'apache

***Mettre le bon path pour chaque certificat***

cd /etc/apache2/sites-available
nano default-ssl.conf

SSLCertificateFile	/etc/ssl/certs/www.etinzon.cefim.cer  
SSLCertificateKeyFile	/etc/ssl/private/www.etinzon.cefim.key

<img src= "https://imgur.com/OuDUdAO.jpg">

systemctl restart apache2

***

## Résultat

<img src= "https://imgur.com/nwn3tqt.jpg">