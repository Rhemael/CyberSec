# 🛡️ MINI-GUIDE : Construire ton Lab de Cybersécurité

**Résumé Essentiel en 3 Pages**

---

## 🎯 Pourquoi créer ton propre lab ?

### La pratique, clé de la maîtrise

Dans le domaine de la cybersécurité, **la théorie seule ne suffit pas**. Tu peux lire 100 livres sur le pentesting, mais sans pratique, tu seras perdu face à un vrai système.

Un lab personnel te permet de :
- ✅ **Pratiquer sans risque** dans un environnement isolé
- ✅ **Apprendre de tes erreurs** sans conséquences légales
- ✅ **Tester des exploits** sur des machines vulnérables
- ✅ **Développer tes compétences** à ton rythme
- ✅ **Préparer des certifications** (OSCP, CEH, etc.)

### Les erreurs courantes des débutants

❌ **Erreur #1** : Tester sur des systèmes de production  
➡️ *Solution* : Créer un environnement isolé et légal

❌ **Erreur #2** : Ne pas documenter ses tests  
➡️ *Solution* : Prendre des notes dès le début

❌ **Erreur #3** : Vouloir tout faire d'un coup  
➡️ *Solution* : Progresser par étapes

---

## 🔧 Ce dont tu as besoin

### Matériel minimum

| **Composant** | **Minimum** | **Recommandé** |
|---------------|-------------|-------------------|
| **CPU** | 4 cœurs | 8 cœurs |
| **RAM** | 16 GB | 32 GB |
| **Stockage** | 100 GB | 250 GB |
| **Virtualisation** | VT-x/AMD-V activé | Obligatoire |

### Logiciels gratuits

- **VirtualBox** ou **VMware Workstation Player** (virtualisation)
- **Kali Linux** (machine d'attaque)
- **Metasploitable 2** (machine vulnérable)
- **Ubuntu Server** (serveur cible)

**Coût total** : **0€** 🎉

---

## 🛠️ Architecture du Lab en 3 étapes

### 🟢 ÉTAPE 1 : Installer VirtualBox

1. Télécharge VirtualBox : https://www.virtualbox.org/
2. Installe et redémarre ton PC
3. Vérifie la virtualisation dans le BIOS (VT-x/AMD-V)

**Durée** : 10 minutes

---

### 🟡 ÉTAPE 2 : Créer le réseau virtuel

**Configuration simple** :

```
        Internet (NAT)
             │
     ┌───────┴───────┐
     │  Réseau Lab   │
     │ 192.168.100.x │
     └───────┬───────┘
             │
    ─────────┴─────────
    │        │        │
  Kali   Metaspl  Ubuntu
  .10      .20      .30
```

**Dans VirtualBox** :
1. Fichier → Gestionnaire de réseau hôte
2. Créer un nouveau réseau
3. Configurer : 192.168.100.1/24

**Durée** : 5 minutes

---

### 🔴 ÉTAPE 3 : Installer les machines virtuelles

#### A. Kali Linux (Attaquant)

1. Télécharge l'ISO : https://www.kali.org/get-kali/
2. Crée une VM :
   - **Nom** : Kali-Attacker
   - **RAM** : 4 GB
   - **CPU** : 2 cœurs
   - **Disque** : 40 GB
3. Configure l'IP : `192.168.100.10`
4. Installe les outils :
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install nmap metasploit-framework hydra wireshark
   ```

#### B. Metasploitable 2 (Cible vulnérable)

1. Télécharge : https://sourceforge.net/projects/metasploitable/
2. Importe dans VirtualBox
3. Configure l'IP : `192.168.100.20`
4. Login : `msfadmin` / `msfadmin`

#### C. Ubuntu Server (Serveur)

1. Télécharge : https://ubuntu.com/download/server
2. Crée une VM (RAM: 2GB, Disque: 20GB)
3. Installe LAMP stack :
   ```bash
   sudo apt install apache2 mysql-server php
   ```
4. Configure l'IP : `192.168.100.30`

**Durée totale** : 1-2 heures

---

## 🎯 Tes 3 premiers tests

### ✅ TEST 1 : Scanner le réseau (5 min)

**Sur Kali** :
```bash
# Découvrir les machines
nmap -sn 192.168.100.0/24

# Scanner Metasploitable
nmap -sV 192.168.100.20
```

**Résultat attendu** : Liste des ports ouverts (21, 22, 23, 80, 139, 445, 3306...)

---

### ✅ TEST 2 : Exploiter une vulnérabilité (10 min)

**Sur Kali** :
```bash
msfconsole
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST 192.168.100.20
exploit
```

**Résultat attendu** : Shell root sur Metasploitable 🎉

---

### ✅ TEST 3 : Capturer du trafic (10 min)

**Sur Kali** :
```bash
# Démarrer Wireshark
sudo wireshark

# Sélectionner l'interface réseau
# Filtre : http

# Générer du trafic
curl http://192.168.100.20
```

**Résultat attendu** : Voir les requêtes HTTP en temps réel

---

## 📚 Ressources gratuites pour aller plus loin

### Plateformes de pratique
1. **HackTheBox** - https://www.hackthebox.eu/ (Machines vulnérables)
2. **TryHackMe** - https://tryhackme.com/ (CTF guidés)
3. **VulnHub** - https://www.vulnhub.com/ (VMs téléchargeables)
4. **PentesterLab** - https://pentesterlab.com/ (Exercices web)

### Formations gratuites
5. **Cybrary** - https://www.cybrary.it/
6. **SANS Cyber Aces** - https://www.cyberaces.org/
7. **OWASP WebGoat** - https://owasp.org/www-project-webgoat/

### Certifications recommandées
8. **CompTIA Security+** (Débutant)
9. **CEH** - Certified Ethical Hacker (Intermédiaire)
10. **OSCP** - Offensive Security (Avancé)

---

## ⚠️ Avertissement légal - À LIRE ABSOLUMENT

### Règles d'or

🔴 **INTERDIT** :
- Tester sur des systèmes que tu ne possèdes pas
- Utiliser ces techniques de manière malveillante
- Exposer ton lab à Internet
- Attaquer des infrastructures réelles

🟢 **AUTORISÉ** :
- Pratiquer dans ton lab personnel
- Participer à des CTF légaux
- Tester avec autorisation écrite
- Apprendre pour se défendre

**La cybersécurité offensive est un outil légal UNIQUEMENT dans un cadre éthique et autorisé.**

---

## 🚀 Prochaines étapes

### Plan d'action sur 30 jours

**Semaine 1** : Configuration du lab  
- ☐ Installer VirtualBox
- ☐ Créer le réseau
- ☐ Installer les 3 VMs
- ☐ Tester la connectivité

**Semaine 2** : Maîtriser les outils  
- ☐ Scanner avec Nmap
- ☐ Capturer avec Wireshark
- ☐ Brute-force avec Hydra
- ☐ Scanner web avec Nikto

**Semaine 3** : Premières exploitations  
- ☐ vsftpd backdoor
- ☐ Samba usermap_script
- ☐ SQL Injection
- ☐ Brute-force SSH

**Semaine 4** : Documentation  
- ☐ Créer ton premier rapport
- ☐ Documenter 3 exploitations
- ☐ Rejoindre HackTheBox
- ☐ Faire ton premier CTF

---

## 🎓 Pour aller encore plus loin...

### 📚 Ebook Complet Disponible

Ce mini-guide est un **aperçu** du contenu complet de l'ebook :  
**"Construire ton premier Lab de Cybersécurité – De zéro à expert"**

**Ce que tu trouveras dans l'ebook complet** :

✅ **200+ pages** de contenu détaillé  
✅ **12 chapitres** progressifs  
✅ **15+ exercices** pratiques guidés  
✅ **Scripts d'automatisation** (Docker, Vagrant, Ansible)  
✅ **Templates de rapports** professionnels  
✅ **Mapping MITRE ATT&CK** complet  
✅ **Captures PCAP** d'exemple avec analyses  
✅ **Vidéos** de démonstration (bonus)  
✅ **Support communautaire** Discord  

### 🔥 OFFRE SPÉCIALE

**Bundle Volume 1 + Volume 2** :  
- Volume 1 : Lab de Cybersécurité  
- Volume 2 : Construis ton mini SOC (SIEM, IDS, Threat Intelligence)

**Prix** : [Lien vers la boutique]

---

## 💬 Rejoins la communauté

**Discord** : [Lien Discord]  
**GitHub** : [Lien GitHub]  
**Twitter** : @CyberLabPro  
**Email** : contact@cyberlab.io

---

## ✅ Checklist de démarrage rapide

Avant de commencer, assure-toi d'avoir :

- [ ] Un PC avec 16GB de RAM minimum
- [ ] VirtualBox installé
- [ ] 100 GB d'espace disque libre
- [ ] Virtualisation activée (BIOS)
- [ ] Connexion Internet stable
- [ ] 2-3 heures de temps libre
- [ ] Envie d'apprendre ! 🚀

---

## 🌟 Citation inspirante

> *"La seule façon d'apprendre la cybersécurité, c'est de mettre les mains dans le code, de casser des systèmes (légalement), et de comprendre comment tout fonctionne de l'intérieur."*  
> — Kevin Mitnick, légende du hacking éthique

---

**🎉 Félicitations !**

Tu as maintenant toutes les bases pour créer ton premier lab de cybersécurité.

**La prochaine étape ?** Passer à l'action ! 🚀

---

*Document créé avec ❤️ pour la communauté cybersécurité*  
*Version 1.0 - Janvier 2025*
