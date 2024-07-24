# Hardening SSH

## Bonnes pratiques - Implémentation SSH

- Références:  
     - [https://cyber.gouv.fr/publications/usage-securise-dopenssh](https://cyber.gouv.fr/publications/usage-securise-dopenssh)  
     - [https://www.ssh-audit.com/hardening_guides.html](https://www.ssh-audit.com/hardening_guides.html)

---

1.  Seule la **version 2** du protocole SSH doit être autorisée.

2.  Les serveurs d’accès distants TELNET, RSH, RLOGIN **doivent être désinstallés** du système.

3.  **SCP ou SFTP** doivent être utilisés en lieu et place de protocoles historiques (RCP, FTP) pour du transfert ou du téléchargement de fichiers.

4.  L’usage de clés DSA n’est pas recommandé.

5.  La taille de clé minimale doit être de **2048 bits pour RSA**.

6.  La taille de clé minimale doit être de **256 bits pour ECDSA**.

7.  Lorsque les clients et les serveurs SSH supportent ECDSA, son usage doit être préféré à RSA.

8.  Les clés doivent être générées dans un contexte où la source d’**aléa est fiable**, ou à défaut dans un environnement où suffisamment d’entropie a été accumulée.

9.  Quelques règles permettent de s’assurer que le réservoir d’entropie est correctement rempli :  
    1.   la machine de génération de clés doit être une machine physique ;
    2.  elle doit disposer de plusieurs sources d’entropie indépendantes ;
    3.  l’aléa ne doit être obtenu qu’après une période d’activité suffisamment importante (plusieurs minutes voire heures).

10.  La clé privée ne doit être connue que de l’entité qui cherche à prouver son identité à un tiers et éventuellement d’une autorité de confiance. Cette clé privée doit être dûment protégée pour en éviter la diffusion à une personne non autorisée

11.  L’AES-128 mode CBC doit être utilisé comme algorithme de chiffrement pour la protection de la clé privée utilisateur par mot de passe.

12. L’algorithme de chiffrement doit reposer sur de l’AES 128, AES 192 ou AES 256, en mode CTR.  
L’intégrité doit reposer sur du HMAC SHA-1, SHA-256 ou SHA-512.

13. Une étape préliminaire à ce durcissement est donc d’user de drapeaux de compilation adéquats. Se rapporter par exemple aux "Recommandations de sécurité relatives à un système GNU/Linux".

14.  L’authentification d’un utilisateur doit se faire à l’aide d’un des mécanismes suivants, par ordre de préférence :
     - par cryptographie asymétrique ECDSA;
     - par cryptographie asymétrique RSA;
     - par cryptographie symétrique (tickets Kerberos par la GSSAPI) ;
     - PAM (ou BSD Auth) permettant de faire appel à des modules d’authentification tiers n’exposant pas le mot de passe utilisateur ou son condensat (OTP) ;
     - par mot de passe vis à vis d’une base de données comme passwd/shadow ou annuaire.

15.  Les droits d’un utilisateur doivent suivre le principe de moindre privilège. La restriction peut porter sur de nombreux paramètres : commandes accessibles, adresses IPs d’origine, droit de redirections ou de forwarding

16.  L’usage du mécanisme d’agent forwarding (option -A de ssh) est recommandé dans les cas où un rebond SSH est nécessaire au travers d’un serveur hôte relais.

17.  Le serveur hôte relais doit être un hôte de confiance.

18.  Chaque utilisateur doit disposer de son propre compte, unique, incessible.

19.  Les accès à un service doivent être restreints aux utilisateurs qui en ont un besoin justifié.  
Cette restriction doit s’appliquer en droits positifs : uniquement ceux explicitement autorisés ont le droit de se connecter en SSH sur un hôte, et éventuellement en provenance d’adresses IP spécifiées.

20.  L’altération de l’environnement par un utilisateur doit être bloquée par défaut. Les variables autorisées à la modification par le client doivent être sélectionnées au cas par cas.

21.  Les commandes lancées par un utilisateur au travers d’une session SSH doivent être réduites au strict nécessaire ; cette restriction peut être mise en place par l’utilisation :
     - de la directive ForceCommand pour un utilisateur donné, dans le fichier sshd_config ;
     - en spécifiant des options dans le fichier authorized_keys ;
     - de binaires dûment protégés comme sudo ou su.

22.  Le serveur SSH doit écouter uniquement sur une adresse d’administration

23.  Lorsque le serveur SSH est exposé à un réseau non maîtrisé, il est recommandé de lui mettre un port d’écoute différent du port par défaut (22).

24.  Il faut privilégier un port inférieur à 1024 afin d’empêcher les tentatives d’usurpation par des services non administrateur sur la machine distante.

25.  Sur un réseau maîtrisé, le serveur SSH doit écouter uniquement sur une interface du réseau d’administration, distinct du réseau opérationnel.

26.  Sauf besoin dûment justifié, toute fonctionnalité de redirections de flux doit être désactivée :
     - au niveau de la configuration du serveur SSH ;
     - au niveau du pare-feu local en bloquant les connexions.

27.  La redirection X11 doit être désactivée sur le serveur.

28. Il est recommandé de créer des ACs distinctes lorsque leurs rôles diffèrent. On aura par exemple :
     - une qui jouera le rôle d’AC « hôte » ;
     - une qui jouera le rôle d’AC «utilisateurs».

29.  Chaque clé privée d’une AC doit être protégée par un mot de passe unique, robuste.

30.  Dans le cas où une clé ne peut plus être considérée comme sûre, l’usage de celle-ci doit être rapidement révoqué au niveau de SSH.

31.  La validation des empreintes SSH hôte envoyées par le serveur DNS ne doit pas se faire sans une vérification complémentaire.

## The Bastion

- Références:
     - [https://ovh.github.io/the-bastion/](https://ovh.github.io/the-bastion/)

---

### Téléchargement

`wget https://github.com/ovh/the-bastion/archive/refs/tags/v3.16.01.tar.gz`  
`mkdir -p /opt/bastion`  
`tar -C /opt/bastion -zxf v3.16.99-rc1.tar.gz`  

### Installation

`/opt/bastion/bin/admin/packages-check.sh -i`

### Setup

`/opt/bastion/bin/admin/install --new-install`

### Check

`/opt/bastion/bin/dev/perl-check.sh`

### Création du premier compte

`/opt/bastion/bin/admin/setup-first-admin-account.sh USERNAME auto`

### Configuration Client (pour se connecter au bastion)

*Création d'un alias pour éviter de se taper la commande entière h24*  
`alias bssh='ssh -t myname@the-bastion.example.org --'`

### Configuration Serveur

*Récupérer la clé EgressKey dans le terminal du bastion*  

     bssh(master)> `selfListEgressKeys`  
     ---the-bastion.example.org----------------------------the-bastion-2.99.99-rc9---  
     => the public part of your personal bastion key  
     --------------------------------------------------------------------------------  
     ~ You can copy one of those keys to a remote machine to get access to it through your account  
     ~ on this bastion, if it is listed in your private access list (check selfListAccesses)  
     ~  
     ~ Always include the from="198.51.100.1/32" part when copying the key to a server!  
     ~  
     ~ fingerprint: SHA256:rMpoCaYPSfRqmOBFOJvEr5uLqxYjqYtRDgUoqUwH2nA (ED25519-256) [2019/07/11]  
     ~ keyline follows, please copy the *whole* line:  
     from="198.51.100.1/32" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnY2NQTKsTDxgcaTE6vHVm9FIbud1rJcYQ/4xUyr+DK johndoe@bssh:1562861572  
     --------------------------------------------------------</selfListEgressKeys>---

*Rajouter la clé dans 'authorized_keys' chez le serveur de destination*  
`echo "from="198.51.100.1/32" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnY2NQTKsTDxgcaTE6vHVm9FIbud1rJcYQ/4xUyr+DK johndoe@bssh:1562861572" >> /root/.ssh/authorized_keys`

*Ajouter l'accès dans le terminal du bastion*  

     bssh(master)> selfAddPersonalAccess --host 198.51.100.42 --port 22 --user root  
     ---the-bastion.example.org----------------------------the-bastion-2.99.99-rc9---  
     => adding private access to a server on your account  
     --------------------------------------------------------------------------------  
     ~ Testing connection to root@198.51.100.42, please wait...  
     Warning: Permanently added '198.51.100.42' (ECDSA) to the list of known hosts.  
     ~ Access to root@198.51.100.42:22 successfully added  
     -----------------------------------------------------</selfAddPersonalAccess>---  

*Vérifier l'accès* 

     bssh(master)> `selfListAccesses`  
     ---the-bastion.example.org----------------------------the-bastion-2.99.99-rc9---  
     => your access list  
     --------------------------------------------------------------------------------  
     ~ Dear johndoe, you have access to the following servers:  
     | IP            | PORT| USER| ACCESS-BY| ADDED-BY| ADDED-AT  |  
     | ------------- | --- | --- | -------- | ------- | --------- |  
     | 198.51.100.42 | 22  | root| personal | johndoe | 2020-05-01|  
     -----------------------------------------------------\</selfListAccesses>---

## Knockd

- Références:
     - [https://goteleport.com/blog/ssh-port-knocking/](https://goteleport.com/blog/ssh-port-knocking/)

---

### Installation

`apt install knockd`

### Configuration

*/etc/knockd.conf*

     [options]  
          UseSyslog  
     
     [openSSH]  
          sequence    = 7000,8000,9000  
          seq_timeout = 5  
          command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 22 -j ACCEPT  
          tcpflags    = syn  
     
     [closeSSH]  
          sequence    = 9000,8000,7000  
          seq_timeout = 5  
          command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT  
          tcpflags    = syn  

*/etc/default/knockd*  

     # control if we start knockd at init or not  
     # 1 = start  
     # anything else = don't start  
     # PLEASE EDIT /etc/knockd.conf BEFORE ENABLING  
     START_KNOCKD=1  
     
     # command line options  
     KNOCKD_OPTS="-i ens33"  

`systemctl start knockd`  
`systemctl enable knockd`

### Configuration iptables

*Via un script pour se simplifier la vie*

     # !/bin/bash  
     
     # Delete current rules  
     iptables -F ; iptables -X  
     
     # Don't f*ck up estabished connection  
     iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
     iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT  
     
     # Authorize localhost port 22 input  
     iptables -t filter -i ens33 --src 127.0.0.1/32 -A INPUT -p TCP --dport 22 -j ACCEPT  
     
     # Authorize port 22 output  
     iptables -t filter -A OUTPUT -p TCP --sport 22 -j ACCEPT  
     
     # Authorize all port 80 traffic  
     iptables -t filter -A INPUT -p TCP --sport 80 -j ACCEPT  
     iptables -t filter -A OUTPUT -p TCP --sport 80 -j ACCEPT  
     
     # Authorize all port 53 traffic  
     iptables -t filter -A INPUT -p TCP --sport 53 -j ACCEPT  
     iptables -t filter -A OUTPUT -p TCP --sport 53 -j ACCEPT  
     
     # Authorize all port 443 traffic  
     iptables -t filter -A INPUT -p TCP --sport 443 -j ACCEPT  
     iptables -t filter -A OUTPUT -p TCP --sport 443 -j ACCEPT  
     
     # Authorize ICMP traffic  
     iptables -t filter -A INPUT -p ICMP -j ACCEPT  
     iptables -t filter -A OUTPUT -p ICMP -j ACCEPT  
     
     # Drop all port 44 connection  
     iptables -A INPUT -p tcp --dport 44 -j REJECT  
     
     # Drop all  
     iptables -t filter -A INPUT -j DROP  
     iptables -t filter -A OUTPUT -j DROP  
     
     # List new rules  
     iptables -L  

### Script Client Knockd

*Script pour permettre d'envoyer la séquence d'ouverture knockd, lancer la session ssh puis d'envoyer le séquence de fermeture knockd (cela éviter d'oublier de fermer le port après la session ssh)*

     #!/bin/bash  
     
     # Target IP address  
     TARGET_IP="192.168.157.129"  
     
     # User  
     USER="natha"  
     
     # Port  
     PORT="44"  
     
     # Private key  
     PRIV_KEY="/home/user/tp_hard/tp_hard"  
     
     # Port knocking sequence to open SSH  
     OPEN_SEQ=(7000 8000 9000)  
     
     # Port knocking sequence to close SSH (reverse order)  
     CLOSE_SEQ=(9000 8000 7000)  
     
     # Knocking sequence sending function  
     knock_sequence() {  
          local ip=\$1  
          shift  
          local ports=("$@")  
          
          for port in "\${ports[@]}"; do  
               knock -v \$ip $port  
               sleep 1  
               done 
          }  
     
     # Open SSH  
     echo "Sending sequence to open SSH..."  
     knock_sequence \$TARGET_IP "${OPEN_SEQ[@]}"  
     
     # Open SSH connection  
     echo "SSH connection to $TARGET_IP"  
     ssh $USER@$TARGET_IP -p $PORT -i $PRIV_KEY  
     
     # Schedule closing sequence   
     echo "Sending sequence to close SSH..."  
     #at now + 1 minute  
     knock_sequence \$TARGET_IP ${CLOSE_SEQ[@]}  
     
     echo "Closing sequence sceduled."  