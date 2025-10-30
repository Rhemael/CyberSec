# 🎯 Mapping MITRE ATT&CK - Lab de Cybersécurité

---

## 📖 Introduction

Ce document mappe les techniques et tactiques MITRE ATT&CK avec les exercices pratiques du lab de cybersécurité. Chaque exercice est associé à des techniques spécifiques du framework MITRE ATT&CK pour une compréhension professionnelle des vecteurs d'attaque.

**MITRE ATT&CK** : Framework de connaissances basé sur l'observation des tactiques et techniques utilisées par les adversaires dans le monde réel.

**Référence** : https://attack.mitre.org/

---

## 🔵 Vue d'ensemble des Tactiques

| **Tactique** | **ID** | **Description** | **Utilisé dans le Lab** |
|--------------|--------|-----------------|---------------------------|
| **Reconnaissance** | TA0043 | Collecte d'informations sur la cible | ✓ Oui |
| **Resource Development** | TA0042 | Préparation des ressources d'attaque | ✓ Oui |
| **Initial Access** | TA0001 | Obtenir l'accès initial au système | ✓ Oui |
| **Execution** | TA0002 | Exécuter du code malveillant | ✓ Oui |
| **Persistence** | TA0003 | Maintenir l'accès au système | ✓ Oui |
| **Privilege Escalation** | TA0004 | Obtenir des privilèges élevés | ✓ Oui |
| **Defense Evasion** | TA0005 | Éviter la détection | ✓ Oui |
| **Credential Access** | TA0006 | Voler des identifiants | ✓ Oui |
| **Discovery** | TA0007 | Explorer l'environnement | ✓ Oui |
| **Lateral Movement** | TA0008 | Se déplacer dans le réseau | ✓ Oui |
| **Collection** | TA0009 | Collecter des données d'intérêt | ✓ Oui |
| **Command and Control** | TA0011 | Communiquer avec les systèmes compromis | ✓ Oui |
| **Exfiltration** | TA0010 | Exfiltrer des données | ✓ Oui |
| **Impact** | TA0040 | Perturber les opérations | Non (lab) |

---

## 💡 Exercice 1 : Reconnaissance Réseau (Niveau Facile)

### Objectif
Scanner un réseau, identifier les hôtes actifs et les services exposés.

### Techniques MITRE ATT&CK Utilisées

| **Technique** | **ID** | **Tactique** | **Description** | **Commande Lab** |
|---------------|--------|--------------|-----------------|------------------|
| **Active Scanning** | T1595 | Reconnaissance | Scanner activement les cibles pour collecter des informations | `nmap -sn 192.168.100.0/24` |
| **Active Scanning: Scanning IP Blocks** | T1595.001 | Reconnaissance | Scanner des blocs d'adresses IP | `nmap -sS 192.168.100.0/24` |
| **Active Scanning: Vulnerability Scanning** | T1595.002 | Reconnaissance | Scanner pour identifier les vulnérabilités | `nmap --script vuln 192.168.100.20` |
| **Network Service Discovery** | T1046 | Discovery | Découvrir les services réseau disponibles | `nmap -sV -p- 192.168.100.20` |
| **System Network Configuration Discovery** | T1016 | Discovery | Découvrir la configuration réseau | `nmap -O 192.168.100.20` |

### Outils Utilisés
- **Nmap** : Scanner de réseau et de ports
- **Netdiscover** : Découverte d'hôtes via ARP

### Détection & Mitigation
- **Détection** : IDS/IPS (Suricata, Snort) peut détecter les scans de ports
- **Mitigation** : 
  - Limiter l'exposition des services
  - Utiliser un pare-feu pour bloquer les scans
  - Implémenter le rate limiting

---

## 🔫 Exercice 2 : Exploitation Web (Niveau Intermédiaire)

### Objectif
Scanner une application web, identifier et exploiter une vulnérabilité (SQL Injection).

### Techniques MITRE ATT&CK Utilisées

| **Technique** | **ID** | **Tactique** | **Description** | **Commande Lab** |
|---------------|--------|--------------|-----------------|------------------|
| **Exploit Public-Facing Application** | T1190 | Initial Access | Exploiter une vulnérabilité dans une application web | `sqlmap -u "http://192.168.100.20/page.php?id=1"` |
| **Web Service: Exploit via Web Service** | T1505.003 | Persistence | Exploiter un service web pour maintenir l'accès | Exploitation SQLi pour obtenir shell |
| **Credential Dumping** | T1003 | Credential Access | Extraire des identifiants de la base de données | `sqlmap -u "..." --passwords` |
| **Data from Information Repositories** | T1213 | Collection | Collecter des données depuis la base de données | `sqlmap -u "..." --dump` |
| **Command and Scripting Interpreter: Unix Shell** | T1059.004 | Execution | Exécuter des commandes via shell | `sqlmap -u "..." --os-shell` |

### Outils Utilisés
- **Nikto** : Scanner de vulnérabilités web
- **SQLMap** : Outil d'exploitation SQL Injection
- **Burp Suite** : Proxy d'interception et scanner web

### Détection & Mitigation
- **Détection** : WAF (Web Application Firewall) peut détecter les tentatives d'injection
- **Mitigation** :
  - Utiliser des requêtes préparées (prepared statements)
  - Valider et assainir toutes les entrées utilisateur
  - Implémenter un WAF

---

## 🔐 Exercice 3 : Post-Exploitation (Niveau Avancé)

### Objectif
Obtenir un accès initial, escalader les privilèges, établir la persistence et exfiltrer des données.

### Scénario : Exploitation vsftpd backdoor + Post-exploitation

### Techniques MITRE ATT&CK Utilisées

| **Technique** | **ID** | **Tactique** | **Description** | **Commande Lab** |
|---------------|--------|--------------|-----------------|------------------|
| **Exploit Public-Facing Application** | T1190 | Initial Access | Exploiter la backdoor vsftpd | `use exploit/unix/ftp/vsftpd_234_backdoor` |
| **Command and Scripting Interpreter** | T1059 | Execution | Exécuter des commandes via shell | Commandes dans le shell obtenu |
| **System Information Discovery** | T1082 | Discovery | Découvrir les informations système | `uname -a`, `cat /etc/issue` |
| **File and Directory Discovery** | T1083 | Discovery | Explorer le système de fichiers | `ls -la /home`, `find / -name "*.txt"` |
| **Account Discovery** | T1087 | Discovery | Énumérer les comptes utilisateurs | `cat /etc/passwd` |
| **Permission Groups Discovery** | T1069 | Discovery | Identifier les groupes et permissions | `id`, `groups` |
| **OS Credential Dumping** | T1003 | Credential Access | Extraire les hashes de mots de passe | `cat /etc/shadow` |
| **Create Account** | T1136 | Persistence | Créer un compte backdoor | `useradd backdoor && echo "backdoor:pass" \| chpasswd` |
| **Scheduled Task/Job: Cron** | T1053.003 | Persistence | Ajouter une tâche cron pour persistence | `echo "* * * * * /bin/bash -i" \| crontab` |
| **Valid Accounts** | T1078 | Persistence | Utiliser des comptes valides pour maintenir l'accès | Connexion avec le compte créé |
| **Data from Local System** | T1005 | Collection | Collecter des fichiers sensibles | `cat /etc/shadow > /tmp/shadow.txt` |
| **Archive Collected Data** | T1560 | Collection | Archiver les données collectées | `tar -czf /tmp/loot.tar.gz /tmp/shadow.txt` |
| **Exfiltration Over C2 Channel** | T1041 | Exfiltration | Exfiltrer via le canal C2 | Transfert via netcat ou autre |

### Outils Utilisés
- **Metasploit Framework** : Exploitation
- **LinPEAS** : Enumération post-exploitation
- **Netcat** : Transfert de fichiers

### Détection & Mitigation
- **Détection** : 
  - SIEM pour corrélation d'événements
  - EDR pour détecter les comportements suspects
  - Monitoring des créations de comptes
- **Mitigation** :
  - Mettre à jour tous les services
  - Implémenter le principe du moindre privilège
  - Monitoring actif et alertes

---

## 🛡️ Autres Scénarios du Lab

### Scénario : Brute-force SSH

| **Technique** | **ID** | **Tactique** | **Description** | **Commande Lab** |
|---------------|--------|--------------|-----------------|------------------|
| **Brute Force: Password Guessing** | T1110.001 | Credential Access | Deviner les mots de passe par brute-force | `hydra -l root -P rockyou.txt ssh://192.168.100.20` |
| **Valid Accounts: Local Accounts** | T1078.003 | Initial Access | Utiliser un compte local compromise | `ssh msfadmin@192.168.100.20` |

### Scénario : Exploitation Samba

| **Technique** | **ID** | **Tactique** | **Description** | **Commande Lab** |
|---------------|--------|--------------|-----------------|------------------|
| **Exploitation of Remote Services** | T1210 | Lateral Movement | Exploiter Samba pour exécution de code | `use exploit/multi/samba/usermap_script` |
| **Remote Services: SMB/Windows Admin Shares** | T1021.002 | Lateral Movement | Utiliser SMB pour mouvement latéral | `smbclient //192.168.100.20/share` |

### Scénario : Capture de trafic réseau

| **Technique** | **ID** | **Tactique** | **Description** | **Commande Lab** |
|---------------|--------|--------------|-----------------|------------------|
| **Network Sniffing** | T1040 | Credential Access | Capturer le trafic réseau pour intercepter des credentials | `tcpdump -i eth0 -w capture.pcap` |
| **Man-in-the-Middle** | T1557 | Credential Access | Intercepter les communications | ARP spoofing + Wireshark |

---

## 📊 Matrice de Mapping Complète

### Tableau Récapitulatif par Exercice

| **Exercice** | **Niveau** | **Tactiques** | **Techniques** | **Nombre de Techniques** |
|--------------|------------|---------------|----------------|---------------------------|
| **Reconnaissance Réseau** | Facile | Reconnaissance, Discovery | T1595, T1595.001, T1595.002, T1046, T1016 | 5 |
| **Exploitation Web** | Intermédiaire | Initial Access, Persistence, Credential Access, Collection, Execution | T1190, T1505.003, T1003, T1213, T1059.004 | 5 |
| **Post-Exploitation** | Avancé | Initial Access, Execution, Discovery, Credential Access, Persistence, Collection, Exfiltration | T1190, T1059, T1082, T1083, T1087, T1069, T1003, T1136, T1053.003, T1078, T1005, T1560, T1041 | 13 |
| **Brute-force SSH** | Intermédiaire | Credential Access, Initial Access | T1110.001, T1078.003 | 2 |
| **Exploitation Samba** | Intermédiaire | Lateral Movement | T1210, T1021.002 | 2 |
| **Capture Trafic** | Intermédiaire | Credential Access | T1040, T1557 | 2 |

### **Total : 29 techniques MITRE ATT&CK couvertes dans le lab**

---

## 📈 Distribution des Techniques par Tactique

| **Tactique** | **Nombre de Techniques** | **Pourcentage** |
|--------------|--------------------------|------------------|
| Discovery | 5 | 17% |
| Credential Access | 4 | 14% |
| Initial Access | 3 | 10% |
| Execution | 2 | 7% |
| Persistence | 3 | 10% |
| Collection | 2 | 7% |
| Exfiltration | 1 | 3% |
| Lateral Movement | 2 | 7% |
| Reconnaissance | 3 | 10% |

---

## 🎓 Progression Pédagogique

### Niveau Débutant
**Exercice 1 : Reconnaissance Réseau**
- Introduction aux scans réseau
- Compréhension de la topologie
- Identification des services

**Techniques apprises** :
- T1595 : Active Scanning
- T1046 : Network Service Discovery
- T1016 : System Network Configuration Discovery

### Niveau Intermédiaire
**Exercice 2 : Exploitation Web**
- Scan de vulnérabilités web
- Exploitation SQL Injection
- Accès aux bases de données

**Techniques apprises** :
- T1190 : Exploit Public-Facing Application
- T1213 : Data from Information Repositories

### Niveau Avancé
**Exercice 3 : Post-Exploitation Complète**
- Obtention accès initial
- Énumération du système
- Escalade de privilèges
- Persistence
- Exfiltration

**Techniques apprises** : 13 techniques complètes

---

## 🔍 Détection & Défense par Technique

### T1595 - Active Scanning

**Détection** :
- Surveillance des connexions réseau inhabituelles
- IDS/IPS (Suricata, Snort)
- Logs firewall

**Mitigation** :
- Rate limiting
- Géo-blocking
- Honeypots

### T1190 - Exploit Public-Facing Application

**Détection** :
- WAF (Web Application Firewall)
- Analyse des logs d'application
- Monitoring des erreurs 500

**Mitigation** :
- Patchs réguliers
- Input validation
- Principe du moindre privilège

### T1110.001 - Brute Force: Password Guessing

**Détection** :
- Fail2ban
- Monitoring des échecs de connexion
- SIEM alerts

**Mitigation** :
- MFA (Multi-Factor Authentication)
- Account lockout policies
- Strong password policies

### T1003 - OS Credential Dumping

**Détection** :
- EDR (Endpoint Detection and Response)
- Monitoring accès à /etc/shadow
- Process monitoring

**Mitigation** :
- Least privilege
- Password hashing salé
- File integrity monitoring

---

## 📊 Matrice de Couverture MITRE ATT&CK

```
┌─────────────────────────────────────────────────────────────┐
│                   MITRE ATT&CK COVERAGE                     │
├─────────────────────────────────────────────────────────────┤
│ Reconnaissance     ████████░░ 80% (4/5 techniques)          │
│ Resource Dev.      ░░░░░░░░░░  0% (0/5 techniques)          │
│ Initial Access     ██████░░░░ 60% (3/5 techniques)          │
│ Execution          ████░░░░░░ 40% (2/5 techniques)          │
│ Persistence        ██████░░░░ 60% (3/5 techniques)          │
│ Privilege Esc.     ███░░░░░░░ 30% (2/7 techniques)          │
│ Defense Evasion    ░░░░░░░░░░  0% (0/10 techniques)         │
│ Credential Access  ████████░░ 80% (4/5 techniques)          │
│ Discovery          ██████████ 100% (5/5 techniques)         │
│ Lateral Movement   ████░░░░░░ 40% (2/5 techniques)          │
│ Collection         ████░░░░░░ 40% (2/5 techniques)          │
│ C&C                ░░░░░░░░░░  0% (0/5 techniques)          │
│ Exfiltration       ██░░░░░░░░ 20% (1/5 techniques)          │
│ Impact             ░░░░░░░░░░  0% (0/5 techniques)          │
└─────────────────────────────────────────────────────────────┘
```

**Couverture globale** : ~35% des techniques MITRE ATT&CK  
**Focus principal** : Discovery, Credential Access, Initial Access

---

## 🎯 Exercices Pratiques Bonus

### Exercice 4 : Privilege Escalation Linux

**Objectif** : Escalader de user à root

**Techniques MITRE** :
- T1068 : Exploitation for Privilege Escalation
- T1548 : Abuse Elevation Control Mechanism

**Steps** :
1. Énumération initiale avec LinPEAS
2. Identification de SUID binaries
3. Exploitation
4. Obtention root shell

### Exercice 5 : Lateral Movement

**Objectif** : Se déplacer d'une machine compromise à une autre

**Techniques MITRE** :
- T1021.001 : Remote Services: SSH
- T1021.002 : Remote Services: SMB

**Steps** :
1. Récupération credentials sur machine 1
2. Identification des autres machines
3. Connexion SSH/SMB vers machine 2
4. Répéter le processus

---

## 📚 Ressources pour Approfondir

### MITRE ATT&CK
- **Site officiel** : https://attack.mitre.org/
- **Navigator** : https://mitre-attack.github.io/attack-navigator/
- **D3FEND** (défense) : https://d3fend.mitre.org/

### Bases de données de Techniques
- **CAPEC** : Common Attack Pattern Enumeration
- **CWE** : Common Weakness Enumeration
- **CVE** : Common Vulnerabilities and Exposures

### Formations MITRE ATT&CK
- **ATT&CK for CTI** : https://attack.mitre.org/resources/training/cti/
- **MITRE Engage** : https://engage.mitre.org/

---

## ✅ Checklist d'Utilisation

Pour chaque exercice réalisé :

- [ ] Identifier les techniques MITRE ATT&CK utilisées
- [ ] Noter les ID des techniques (Txxxx)
- [ ] Comprendre la tactique associée
- [ ] Documenter les commandes utilisées
- [ ] Rechercher les méthodes de détection
- [ ] Proposer des mitigations
- [ ] Créer un rapport avec mapping MITRE

---

## 🔗 Intégration dans les Rapports

### Template de Section MITRE dans un Rapport

```markdown
## Mapping MITRE ATT&CK

### Techniques Utilisées

| ID | Technique | Tactique | Description |
|----|-----------|----------|-------------|
| T1595 | Active Scanning | Reconnaissance | Scan Nmap du réseau cible |
| T1190 | Exploit Public-Facing Application | Initial Access | Exploitation vsftpd backdoor |
| T1059 | Command and Scripting Interpreter | Execution | Shell bash obtenu |

### Matrice ATT&CK

[Insérer capture d'écran du Navigator MITRE]

### Recommandations de Détection

Pour T1595 (Active Scanning) :
- Implémenter IDS/IPS
- Configurer des alertes sur les scans de ports
- Utiliser honeypots
```

---

## 🎓 Conclusion

Ce mapping MITRE ATT&CK couvre **29 techniques** réparties sur **9 tactiques** différentes. Il fournit une base solide pour :

✅ Comprendre les vecteurs d'attaque réels  
✅ Documenter professionnellement les tests  
✅ Communiquer avec les équipes SOC  
✅ Se préparer aux certifications (OSCP, GIAC, etc.)  
✅ Contribuer à la Threat Intelligence  

**Le framework MITRE ATT&CK est devenu le langage universel de la cybersécurité offensive et défensive.**

---

*Dernière mise à jour : Janvier 2025*  
*Basé sur MITRE ATT&CK v14*