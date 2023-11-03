# Déploiement de Rudder

## Contexte
Vous êtes un administrateur système dans une entreprise qui souhaite améliorer sa gestion des services informatiques en adoptant les principes ITIL. Votre mission consiste à configurer et à utiliser Rudder pour automatiser la gestion des configurations, renforcer la sécurité, installer des applications et gérer les utilisateurs.

## Tâche 1 : Installation et Configuration du Serveur Rudder
**1.1 Installation**

Installez Rudder Server sur la machine virtuelle serveur dédiée

>*sudo wget --quiet -O /etc/apt/trusted.gpg.d/rudder_apt_key.gpg "https://repository.rudder.io/apt/rudder_apt_key.gpg"*

>*sudo nano /etc/apt/sources.list.d/rudder.list*

>Ajouter la ligne :  
>*deb [trusted=yes] http://repository.rudder.io/apt/8.0/ jammy main*

>*sudo apt-get update*

>*sudo apt-get install rudder-server*

>*sudo apt-get upgrade*

>*rudder server create-user -u n.etinzon*

***

**1.2 Validation**

Connectez-vous à l'interface web de Rudder, vérifiez l'état du serveur et assurez-vous qu'il est prêt à communiquer avec les agents.

<img src= "https://imgur.com/wZVecz7.jpg">

## Tâche 2 : Installation et Configuration d'un Agent Rudder
**2.1 Machine client Linux**

Installez l'agent Rudder sur la machine cliente Linux, et configurez-la pour qu'elle communique avec le serveur.

>*sudo wget --quiet -O /etc/apt/trusted.gpg.d/rudder_apt_key.gpg "https://repository.rudder.io/apt/rudder_apt_key.gpg"*

>*sudo nano /etc/apt/sources.list.d/rudder.list*

>Ajouter la ligne :  
>*deb http://repository.rudder.io/apt/8.0/ jammy main*

>*sudo apt-get install rudder-agent*

>*rudder agent policy-server 163.172.163.218*

>*sudo rudder agent inventory*

**2.2 Validation**

Assurez-vous que l'agent apparaisse dans l'interface web de Rudder et soit autorisée.

<img src= "https://imgur.com/bqM7HPY.jpg">

## Tâche 3 : Renforcement des Configurations Systèmes

**3.1 Technique de Sécurité**

Sur les deux machines :

>Création de comptes : S'assurer que les compte,s "user01" et "user02" sont existants. User01 a un shell en "bash", user02 en "nologin". Les homes seront dans "/home/nom_user"
>>*sudo useradd -m -s /usr/bin/bash user01*  
>>*sudo useradd -m -s /usr/bin/nologin user02*

<img src= "https://imgur.com/H0faw0L.jpg">

***

>Désactivation des comptes : S'assurer que le compte "user02" est désactivé.
>>*sudo usermod -L user02*

***

>Restriction des permissions root : user01" doit avoir le droit d'utiliser sudo, uniquement pour consulter les log dans "/var/log/syslog".
>>*sudo nano /etc/sudoers*
>>Ajouter les lignes :
>>>&#35;Allow user1 to view /var/log/syslog  
>>>user1   ALL=(root) /bin/nano var/log/syslog/*

***

>Configuration du Pare-feu : Autoriser uniquement les ports 22 (SSH), 80 (HTTP), 5309 et 443 (HTTPS). Bloquer tous les autres ports.
>>*sudo ufw allow 22*
>>*sudo ufw allow 80*
>>*sudo ufw allow 5309*
>>*sudo ufw allow 443*
>>*sudo ufw enable*

<img src= "https://imgur.com/Ywm0KvA.jpg">

***

>Mise à jour des Packages : Appliquer toutes les mises à jour de sécurité disponibles.
>>*sudo apt-get update*
>>*sudo apt-get upgrade*

***

>Installation de Packages : Installer "fail2ban" et "apache2" et s'assurer du démarrage des services.
>>*sudo apt-get install apache2*
>>*sudo apt-get install fail2ban*

<img src= "https://imgur.com/vlSH3Ba.jpg">

***

>Déploiement de fichiers : Déployer une page web contenant l'IP du serveur.

<img src= "https://imgur.com/hGNjgYd.jpg">

***

>Renforcer la configuration SSH, mais sans rester dehors.
>>Générer une paire de clé sur la machine locale
>>>*ssh-keygen*
>>>*cat ~/.ssh/id_rsa.pub*
>>>Copier le contenu
>>>Sur l'hôte distant, coller la clé dans /home/n.etinzon/.ssh/authorized_keys
>>>Passer le paramètre *PasswordAuthentification yes* => *PasswordAuthentification no* dans /etc/ssh/ssh_config
>>>*sudo nano /etc/ssh/ssh_config*

<img src= "https://imgur.com/qFKnoLM.jpg">

## Tâche 4 : Audit et Conformité

**4.1 Audit des Configurations**

Utilisez les fonctionnalités d'audit de Rudder pour vérifier la conformité des machines avec les configurations souhaitées.

<img src= "https://imgur.com/ZTZ2Hah.jpg">

***

**4.2 Rapport de Conformité**

Générez un rapport de conformité à partir de l'interface web de Rudder et analysez les résultats.

Possibilité d'ajouter d'un module pour avoir un pdf.

## Tâche 5 : Résolution de Problèmes et Scénarios Pratiques

**5.1 Diagnostic**

Diagnostiquez et résolvez un problème de configuration sur l'une des machines, simulé ou réel.

<img src= "https://imgur.com/bzQ6n4N.jpg">

***

**5.2 Scénario Pratique**

Répondez à une demande de changement fictive, en modifiant les configurations sur les machines via Rudder.

<img src= "https://imgur.com/FBv3C2a.jpg">

<img src= "https://imgur.com/sRzv76w.jpg">
 
***

**Résultat :**

<img src= "https://imgur.com/eQ6k4sf.jpg">

## Tâche 6 : Intégration avec ITIL, Amélioration Continue et Recommandations

**6.1 Alignement ITIL, Analyse et Recommandations**

Documentez comment les actions réalisées s'alignent avec les processus ITIL, en particulier la Gestion des Services et la Gestion des Configurations.  
Identifiez les domaines d'amélioration et les recommandations dans la manière dont Rudder est utilisé et proposez des actions concrètes.

<img src= "https://imgur.com/wIDlnSw.jpg">