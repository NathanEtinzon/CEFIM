# Internal Write-up

## Enumération

### Nmap

#### Commande
`nmap -T4 -sC -sV -Pn -p- 10.10.33.91`

#### Informations
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)  
| ssh-hostkey:   
|   2048 6e:fa:ef:be:f6:5f:98:b9:59:7b:f7:8e:b9:c5:62:1e (RSA)  
|   256 ed:64:ed:33:e5:c9:30:58:ba:23:04:0d:14:eb:30:e9 (ECDSA)  
|_  256 b0:7f:7f:7b:52:62:62:2a:60:d4:3d:36:fa:89:ee:ff (EdDSA)  
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))  
|_http-server-header: Apache/2.4.29 (Ubuntu)  
|_http-title: Apache2 Ubuntu Default Page: It works

***

### Gobuster

#### Commandes
`gobuster dir -u http://10.10.33.91/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 100`  
`gobuster dir -u http://10.10.33.91/wordpress -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 100`  
`gobuster dir -u http://10.10.33.91/phpmyadmin -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 100`  
`gobuster dir -u http://10.10.33.91/blog -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 100`

#### Informations
/wordpress (Status: 301)  
	/wp-content (Status: 301)  
	/wp-includes (Status: 301)  
	/wp-admin (Status: 301)  
	/wp-login.php  

/javascript (Status: 301)  

/blog (Status: 301)  
	/wp-content (Status: 301)  
	/wp-includes (Status: 301)  
	/wp-admin (Status: 301)  
	/wp-login.php  

/phpmyadmin (Status: 301)  
	/themes (Status: 301)  
	/templates (Status: 403)  
	/doc (Status: 301)  
	/js (Status: 301)  
	/libraries (Status: 403)  
	/setup (Status: 401)  
	/sql (Status: 301)  
	/locale (Status: 301)  

/server-status (Status: 403)  

***

### Wappalizer

#### Informations
Apache/2.4.29  
WordPress/5.4.2  
Theme : Twenty Seventeen  
phpMyAdmin  
Google Font API  
RSS  
CodeMirror  
Apache HTTP Server  
PHP  
MySQL  
jQuery  
jQuery UI  
jQuery Migrate  

***

### WPScan

#### Commande
`wpscan -h http://10.10.33.91/wordpress`

#### Informations

[+] XML-RPC seems to be enabled: http://10.10.33.91/wordpress/xmlrpc.php  
 | Found By: Direct Access (Aggressive Detection)  
 | Confidence: 100%  
 | References:  
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API  
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner  
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos  
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login	<= Succès  
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access  

[+] WordPress readme found: http://10.10.33.91/wordpress/readme.html  
 | Found By: Direct Access (Aggressive Detection)  
 | Confidence: 100%  

[+] The external WP-Cron seems to be enabled: http://10.10.33.91/wordpress/wp-cron.php  
 | Found By: Direct Access (Aggressive Detection)  
 | Confidence: 60%  
 | References:  
 |  - https://www.iplocation.net/defend-wordpress-from-ddos  
 |  - https://github.com/wpscanteam/wpscan/issues/1299  

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).  
 | Found By: Emoji Settings (Passive Detection)  
 |  - http://10.10.33.91/wordpress/, Match: 'wp-includes\/js\/wp-emoji-release.min.js?ver=5.4.2'  
 | Confirmed By: Meta Generator (Passive Detection)  
 |  - http://10.10.33.91/wordpress/, Match: 'WordPress 5.4.2'  

***

## Accès initial

> - Ajouter internal.thm dans /etc/host
> - Accèder à http://10.10.33.91/wordpress/wp-login.php  
> - Rentrer les identifiants "admin:my2boys" (récupérer via metasploit auxiliary/scanner/http/wordpress_xmlrpc_login)  
> - Naviguer vers “Appearance > Theme Editor > 404.php"
> - Remplacer le code par un webshell php
> - Lancer un listener (`nc -lvnp 4444`)
> - Accèder à la page http://internal.thm/blog/wp-content/themes/twentyseventeen/404.php

## Escalade de privilège

> - Upgrader du webshell vers un meterpreter
> - Executer post(multi/recon/local_exploit_suggester)  
**Résultat :**  
>> 1.   exploit/linux/local/cve_2021_3493_overlayfs                         Yes                      The target appears to be vulnerable.  
>> 2.   exploit/linux/local/cve_2021_4034_pwnkit_lpe_pkexec                 Yes                      The target is vulnerable.  
>> 3.  exploit/linux/local/cve_2022_0995_watch_queue                        Yes                      The target appears to be vulnerable.  
>> 4.   exploit/linux/local/docker_cgroup_escape                            Yes                      The target is vulnerable. IF host OS is Ubuntu, kernel version 4.15.0-112-generic is vulnerable  
>> 5.   exploit/linux/local/nested_namespace_idmap_limit_priv_esc           Yes                      The target appears to be vulnerable.  
>> 6.   exploit/linux/local/pkexec                                          Yes                      The service is running, but could not be validated.  
>> 7.   exploit/linux/local/ptrace_traceme_pkexec_helper                    Yes                      The target appears to be vulnerable.  
>> 8.   exploit/linux/local/su_login                                        Yes                      The target appears to be vulnerable.  
>> 9.   exploit/linux/local/sudo_baron_samedit                              Yes                      The target appears to be vulnerable. sudo 1.8.21.2 is a vulnerable build.  
>> 10.  exploit/linux/local/sudoedit_bypass_priv_esc                        Yes                      The target appears to be vulnerable. Sudo 1.8.21p2.pre.3ubuntu1.2 is vulnerable, but unable to determine editable file. OS can NOT be exploited by this module  

> - Test exploit/linux/local/cve_2021_3493_overlayfs
> - **BINGO** Du premier coup!
> - On a un shell root, on fait ce que l'on veut

