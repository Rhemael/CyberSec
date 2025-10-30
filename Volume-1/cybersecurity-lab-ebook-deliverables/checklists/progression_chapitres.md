# 📚 Checklist de Progression par Chapitre

---

## 🎯 Objectif

Cette checklist vous permet de suivre votre progression tout au long de l'ebook **"Construire ton premier Lab de Cybersécurité"**. Cochez chaque élément au fur et à mesure de votre avancée.

---

## 📖 Introduction

### Compréhension
- [ ] J'ai lu l'introduction complète
- [ ] Je comprends pourquoi créer un lab de cybersécurité
- [ ] Je connais les erreurs fréquentes des débutants
- [ ] J'ai défini mes objectifs d'apprentissage personnels

### Préparation
- [ ] Matériel vérifié (CPU, RAM, Stockage)
- [ ] Logiciels prérequis installés
- [ ] Espace de travail organisé

---

## 🏭 Chapitre 1 : Les fondations d'un environnement sûr

### Lecture & Compréhension
- [ ] Chapitre 1 lu en entier
- [ ] Je comprends les différents outils de virtualisation
- [ ] J'ai consulté le tableau comparatif (VirtualBox vs VMware vs Proxmox)
- [ ] J'ai choisi mon outil de virtualisation

### Pratique
- [ ] VirtualBox/VMware/Proxmox installé
- [ ] Première VM de test créée
- [ ] Checklist du matériel complétée
- [ ] Virtualisation activée dans le BIOS (VT-x/AMD-V)

### Maîtrise
- [ ] Je peux créer une VM de A à Z
- [ ] Je comprends les concepts de virtualisation

**Score de progression : ___ / 10**

---

## 🔌 Chapitre 2 : Créer ton réseau virtuel

### Lecture & Compréhension
- [ ] Chapitre 2 lu en entier
- [ ] Je comprends les différents types de réseaux (NAT, Host-Only, Internal)
- [ ] J'ai étudié les schémas de topologie
- [ ] J'ai lu les astuces d'isolation réseau
- [ ] J'ai noté les erreurs à éviter

### Pratique
- [ ] Réseau 192.168.100.0/24 créé
- [ ] Configuration Host-Only réalisée
- [ ] Script `setup_lab_network.sh` exécuté
- [ ] Test de connectivité réussi entre VMs
- [ ] Schéma de ma topologie dessiné

### Maîtrise
- [ ] Je peux expliquer la différence entre NAT et Host-Only
- [ ] Je sais configurer l'isolation réseau
- [ ] Mon lab est correctement segmenté

**Score de progression : ___ / 10**

---

## 🐧 Chapitre 3 : Installation des systèmes clés

### Lecture & Compréhension
- [ ] Chapitre 3 lu en entier
- [ ] Tutoriels pas à pas consultés
- [ ] Tableau récapitulatif des configurations étudié

### Installation Kali Linux
- [ ] ISO Kali Linux téléchargé
- [ ] VM Kali créée (4GB RAM, 2 CPUs)
- [ ] Kali installé avec succès
- [ ] IP statique configurée (192.168.100.10)
- [ ] Script `install_kali.sh` exécuté
- [ ] Outils de pentesting vérifiés

### Installation Metasploitable
- [ ] ISO Metasploitable téléchargé
- [ ] VM Metasploitable créée (1GB RAM)
- [ ] IP statique configurée (192.168.100.20)
- [ ] Script `setup_metasploitable.sh` exécuté
- [ ] Services vulnérables vérifiés

### Installation Ubuntu Server
- [ ] ISO Ubuntu Server téléchargé
- [ ] VM Ubuntu créée (2GB RAM)
- [ ] LAMP stack installé
- [ ] IP statique configurée (192.168.100.30)
- [ ] Services vérifiés (Apache, MySQL, SSH)

### Maîtrise
- [ ] Toutes les VMs démarrent sans erreur
- [ ] Je peux me connecter à chaque VM
- [ ] La connectivité réseau fonctionne

**Score de progression : ___ / 10**

---

## 🛠️ Chapitre 4 : Tes premiers outils d'analyse et d'attaque

### Lecture & Compréhension
- [ ] Chapitre 4 lu en entier
- [ ] Cas d'usage de chaque outil compris

### Nmap
- [ ] Nmap installé et testé
- [ ] Scan de découverte réalisé : `nmap -sn 192.168.100.0/24`
- [ ] Scan de ports complet : `nmap -p- 192.168.100.20`
- [ ] Scan avec détection de version : `nmap -sV 192.168.100.20`
- [ ] Scripts NSE testés : `nmap --script vuln 192.168.100.20`

### Burp Suite
- [ ] Burp Suite installé
- [ ] Proxy configuré dans le navigateur
- [ ] Interception de requêtes HTTP testée
- [ ] Scanner web utilisé

### Hydra
- [ ] Hydra installé
- [ ] Brute-force SSH testé : `hydra -l msfadmin -p msfadmin ssh://192.168.100.20`
- [ ] Brute-force FTP testé
- [ ] Liste de mots de passe téléchargée (rockyou.txt)

### Wireshark
- [ ] Wireshark installé
- [ ] Capture de trafic réalisée
- [ ] Filtres appliqués (http, tcp, ip.addr)
- [ ] Analyse d'un fichier PCAP effectuée

### Exercices pratiques
- [ ] Exercice 1 : Scan réseau terminé
- [ ] Exercice 2 : Énumération de services terminé
- [ ] Exercice 3 : Capture de trafic terminé

**Score de progression : ___ / 10**

---

## 🎯 Chapitre 5 : Scénarios de tests pratiques

### Scénario 1 : Exploitation de vulnérabilité web
- [ ] Scénario 1 lu et compris
- [ ] Scan Nikto exécuté : `nikto -h http://192.168.100.20`
- [ ] Vulnérabilités identifiées
- [ ] Exploitation réussie (SQL injection ou autre)
- [ ] Résultats documentés

### Scénario 2 : Brute-force SSH
- [ ] Scénario 2 lu et compris
- [ ] Wordlist préparée
- [ ] Attaque Hydra lancée : `hydra -L users.txt -P passwords.txt ssh://192.168.100.20`
- [ ] Accès SSH obtenu
- [ ] Temps d'attaque mesuré et noté

### Scénario 3 : Capture et analyse de trafic
- [ ] Scénario 3 lu et compris
- [ ] Wireshark lancé en mode capture
- [ ] Trafic généré (HTTP, FTP, SSH)
- [ ] Fichier PCAP sauvegardé
- [ ] Analyse effectuée : mots de passe HTTP identifiés
- [ ] Graphiques et explications compris

### Interprétation des résultats
- [ ] Je comprends les résultats attendus de chaque scénario
- [ ] J'ai comparé mes résultats avec ceux de l'ebook
- [ ] J'ai identifié les différences et les raisons

**Score de progression : ___ / 10**

---

## 📝 Chapitre 6 : Journal et documentation professionnelle

### Lecture & Compréhension
- [ ] Chapitre 6 lu en entier
- [ ] Importance de la documentation comprise
- [ ] Modèle de rapport étudié

### Création de rapports
- [ ] Template `rapport_lab_template.md` téléchargé
- [ ] Premier rapport créé (Markdown ou Word)
- [ ] Rapport incluant : objectif, méthodologie, résultats
- [ ] Captures d'écran intégrées
- [ ] Recommandations rédigées

### Organisation
- [ ] Dossier `/root/lab/reports` organisé
- [ ] Convention de nommage adoptée (ex: 2025-01-15_metasploitable_test.md)
- [ ] Historique des tests conservé

### Exemple de rapport complet
- [ ] Rapport d'exemple de l'ebook étudié
- [ ] Mon propre rapport complet rédigé
- [ ] Rapport revu et corrigé

**Score de progression : ___ / 10**

---

## 🔧 Chapitre 7 : Maintenir et faire évoluer ton lab

### Maintenance
- [ ] Chapitre 7 lu en entier
- [ ] Snapshots créés pour toutes les VMs
- [ ] Procédure de sauvegarde définie
- [ ] Plan de sauvegarde régulière établi
- [ ] Mise à jour des outils effectuée

### Snapshots & Sauvegardes
- [ ] Snapshot "Clean Install" créé pour Kali
- [ ] Snapshot "Clean Install" créé pour Metasploitable
- [ ] Snapshot "Clean Install" créé pour Ubuntu
- [ ] Test de restauration effectué

### Extensions possibles
- [ ] J'ai exploré les options d'extensions (pfSense, Splunk, Wazuh)
- [ ] J'ai sélectionné une extension à implémenter

#### pfSense (optionnel)
- [ ] pfSense installé et configuré
- [ ] Segmentation réseau implémentée
- [ ] Règles de pare-feu configurées

#### Splunk (optionnel)
- [ ] Splunk installé
- [ ] Logs collectés depuis les VMs
- [ ] Dashboards créés
- [ ] Alertes configurées

#### Wazuh (optionnel)
- [ ] Wazuh installé
- [ ] Agents déployés sur les VMs
- [ ] Détection d'intrusion testée

### Checklist finale
- [ ] Checklist de progression complète
- [ ] Checklist de vérification du lab complétée
- [ ] Tous les exercices réalisés
- [ ] Tous les scénarios testés

**Score de progression : ___ / 10**

---

## 🎓 Conclusion & Prochaines Étapes

### Récapitulation
- [ ] Conclusion de l'ebook lue
- [ ] Glossaire technique consulté
- [ ] Index alphabétique utilisé

### Auto-évaluation
- [ ] Je peux créer un lab de A à Z de manière autonome
- [ ] Je maîtrise les outils de base (Nmap, Metasploit, Hydra, Wireshark)
- [ ] Je sais documenter mes tests de manière professionnelle
- [ ] Je comprends les vulnérabilités communes et leur exploitation

### Checklist récapitulative finale
- [ ] Lab opérationnel à 100%
- [ ] Au moins 3 exploitations réussies
- [ ] Au moins 2 rapports complets rédigés
- [ ] Mapping MITRE ATT&CK compris et appliqué
- [ ] Structure de dossiers organisée
- [ ] Sauvegardes en place

### Continuer l'apprentissage
- [ ] M'inscrire sur HackTheBox ou TryHackMe
- [ ] Rejoindre des CTF en ligne
- [ ] Consulter les 10 ressources gratuites recommandées
- [ ] Envisager une certification (CompTIA Security+, CEH, OSCP)

### Volume 2 : Construis ton mini SOC
- [ ] Je suis intéressé(e) par le Volume 2
- [ ] Je me suis inscrit(e) pour être notifié(e) de sa sortie

---

## 🏆 Score Global de Progression

**Calcul du score :**

| **Chapitre** | **Score (/10)** |
|--------------|------------------|
| Introduction | ___ |
| Chapitre 1 | ___ |
| Chapitre 2 | ___ |
| Chapitre 3 | ___ |
| Chapitre 4 | ___ |
| Chapitre 5 | ___ |
| Chapitre 6 | ___ |
| Chapitre 7 | ___ |
| **TOTAL** | **___ / 80** |

### Interprétation

- **70-80** : 🎉 **Excellent !** Vous maîtrisez parfaitement votre lab
- **50-69** : 🚀 **Très bien !** Quelques points à consolider
- **30-49** : 💪 **Bien !** Continuez vos efforts
- **0-29** : 📚 **Début de parcours** - Prenez votre temps

---

## 💬 Notes Personnelles

### Difficultés rencontrées

```
[Notez ici les difficultés que vous avez rencontrées]



```

### Victoires & Succès

```
[Notez vos succès et moments de fierté]



```

### Prochains objectifs

```
[Définissez vos prochains objectifs d'apprentissage]

1. 
2. 
3. 

```

---

**🎓 Félicitations pour votre progression !**

*"La maîtrise vient avec la pratique constante. Continuez à apprendre, à expérimenter et à partager vos connaissances."*
