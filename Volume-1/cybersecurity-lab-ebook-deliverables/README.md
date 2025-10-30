# 🛡️ Construire ton premier Lab de Cybersécurité

## 📖 À propos de ce projet

Ce dépôt contient tous les **livrables techniques** accompagnant l'ebook *"Construire ton premier Lab de Cybersécurité – De zéro à expert en environnement virtuel sécurisé"*.

### 🎯 Objectif

Fournir un environnement de laboratoire de cybersécurité complet, automatisé et isolé, utilisable avec des outils gratuits et open source.

## 🏗️ Architecture du Lab

### Composants principaux

- **Kali Linux** : Distribution d'attaque et de tests de pénétration
- **Metasploitable 2/3** : Machine volontairement vulnérable pour les tests
- **Ubuntu Server** : Serveur cible pour les tests d'exploitation
- **pfSense** : Firewall et routeur pour la segmentation réseau
- **ELK Stack** (optionnel) : Surveillance et analyse des logs
- **Snort/Suricata** (optionnel) : Système de détection d'intrusion

### Topologie réseau

```
┌─────────────────────────────────────────────────────┐
│                  Internet (NAT)                     │
└─────────────────────┬───────────────────────────────┘
                      │
              ┌───────┴────────┐
              │   pfSense FW   │
              │  192.168.1.1   │
              └───────┬────────┘
                      │
        ──────────────┴──────────────
        │             │             │
   ┌────┴────┐  ┌────┴────┐  ┌────┴─────┐
   │  Kali   │  │ Metaspl │  │  Ubuntu  │
   │ .1.10   │  │  .1.20  │  │   .1.30  │
   └─────────┘  └─────────┘  └──────────┘
   (Attaquant)  (Cible vuln) (Serveur)
```

## 🚀 Démarrage rapide

### Prérequis

- **Matériel recommandé** :
  - CPU : 4 cœurs minimum (8 recommandés)
  - RAM : 16 GB minimum (32 GB recommandés)
  - Stockage : 100 GB d'espace libre
  - Virtualisation activée dans le BIOS (VT-x/AMD-V)

- **Logiciels** :
  - VirtualBox 7.0+ ou VMware Workstation
  - Docker & Docker Compose (optionnel)
  - Vagrant (optionnel pour automatisation)

### Installation avec Docker

```bash
# Cloner le dépôt
git clone https://github.com/your-username/cybersecurity-lab-ebook-deliverables.git
cd cybersecurity-lab-ebook-deliverables

# Lancer l'environnement
docker-compose up -d

# Vérifier le statut
docker-compose ps
```

### Installation avec Vagrant

```bash
# Initialiser les VMs
vagrant up

# SSH dans Kali Linux
vagrant ssh kali

# Gérer les VMs
vagrant halt      # Arrêter
vagrant destroy   # Supprimer
```

### Installation manuelle

Consultez les scripts dans le dossier `scripts/` pour une installation pas à pas.

## 📁 Structure du projet

```
.
├── README.md                          # Ce fichier
├── LICENSE                            # Licence MIT
├── docker-compose.yml                 # Configuration Docker
├── Vagrantfile                        # Configuration Vagrant
├── scripts/                           # Scripts d'installation
│   ├── install_kali.sh               # Installation Kali Linux
│   ├── setup_metasploitable.sh       # Configuration Metasploitable
│   ├── setup_lab_network.sh          # Configuration réseau
│   └── ansible/                      # Playbooks Ansible
│       └── lab_setup.yml             # Setup automatisé
├── templates/                         # Templates de documentation
│   ├── rapport_lab_template.md       # Rapport Markdown
│   └── commandes_essentielles.md     # Référence commandes
├── checklists/                        # Listes de vérification
│   ├── verification_lab.md           # Checklist installation
│   └── progression_chapitres.md      # Suivi progression
├── pcaps/                             # Exemples de captures réseau
│   └── README_pcaps.md               # Descriptions
├── mitre-attack/                      # Mapping MITRE ATT&CK
│   └── mapping_mitre_attack.md       # Tableaux de correspondance
└── lead-magnet/                       # Guide promotionnel
    └── mini_guide_3_pages.md         # Résumé de 3 pages
```

## 🎓 Exercices pratiques inclus

### Exercice 1 : Reconnaissance réseau (Facile)
- Scanner un réseau avec Nmap
- Identifier les services actifs
- Mapper la topologie

### Exercice 2 : Exploitation web (Intermédiaire)
- Scanner une application web avec Nikto
- Exploiter une injection SQL
- Obtenir un accès shell

### Exercice 3 : Post-exploitation (Avancé)
- Escalade de privilèges Linux
- Persistence et backdoors
- Exfiltration de données

## 📊 Mapping MITRE ATT&CK

Chaque exercice est mappé aux techniques MITRE ATT&CK pour une compréhension professionnelle des tactiques et techniques utilisées.

Consultez `mitre-attack/mapping_mitre_attack.md` pour les détails.

## 📝 Documentation et rapports

Utilisez les templates dans `templates/` pour documenter vos tests :

- **rapport_lab_template.md** : Format Markdown pour GitHub
- **commandes_essentielles.md** : Référence rapide des commandes

Exemple de rapport pré-rempli avec un scénario complet inclus.

## ✅ Checklists

- **Verification du lab** : `checklists/verification_lab.md`
- **Progression par chapitre** : `checklists/progression_chapitres.md`

## 🔒 Avertissement légal

⚠️ **IMPORTANT** : Cet environnement est destiné UNIQUEMENT à des fins éducatives et de formation.

- N'utilisez JAMAIS ces techniques sur des systèmes que vous ne possédez pas
- Ne testez QUE dans des environnements isolés et contrôlés
- Respectez toujours les lois locales et internationales
- L'utilisation malveillante de ces outils est illégale

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/amelioration`)
3. Commit vos changements (`git commit -m 'Ajout d\'une fonctionnalité'`)
4. Push vers la branche (`git push origin feature/amelioration`)
5. Ouvrir une Pull Request

## 📚 Ressources supplémentaires

### Labs en ligne gratuits
- [HackTheBox](https://www.hackthebox.eu/)
- [TryHackMe](https://tryhackme.com/)
- [PentesterLab](https://pentesterlab.com/)
- [VulnHub](https://www.vulnhub.com/)

### Formations gratuites
- [Cybrary](https://www.cybrary.it/)
- [SANS Cyber Aces](https://www.cyberaces.org/)
- [OWASP WebGoat](https://owasp.org/www-project-webgoat/)

### Certifications recommandées
- CompTIA Security+
- CEH (Certified Ethical Hacker)
- OSCP (Offensive Security Certified Professional)
- GIAC Security Essentials (GSEC)

## 📧 Support

Pour toute question ou problème :
- Ouvrez une issue sur GitHub
- Consultez la FAQ dans l'ebook
- Rejoignez notre communauté Discord [lien]

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🎉 Découvrez le Volume 2

**"Construis ton mini SOC"** - Bientôt disponible !

Apprenez à créer un Security Operations Center complet avec :
- SIEM avec ELK Stack
- Détection d'intrusion avec Suricata
- Analyse de malware avec Cuckoo Sandbox
- Threat Intelligence avec MISP

---

**Créé avec ❤️ pour la communauté cybersécurité**

*"La meilleure façon d'apprendre la cybersécurité, c'est de pratiquer dans un environnement sûr."*
