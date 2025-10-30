#!/bin/bash

# ============================================
# Script de configuration Metasploitable 2/3
# Pour Lab de Cybersécurité
# ============================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Configuration Metasploitable${NC}"
echo -e "${GREEN}========================================${NC}"

# Vérification root
if [ "$EUID" -ne 0 ]; then 
   echo -e "${RED}[!] Ce script doit être exécuté en tant que root${NC}"
   exit 1
fi

echo -e "${YELLOW}[*] Vérification de la version...${NC}"
if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    echo -e "${GREEN}[✓] Distribution: $DISTRIB_DESCRIPTION${NC}"
fi

echo -e "${YELLOW}[*] Configuration de l'adresse IP...${NC}"
# Configuration IP statique (à adapter selon votre réseau)
IP_ADDRESS="192.168.100.20"
NETMASK="255.255.255.0"
GATEWAY="192.168.100.1"

cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address $IP_ADDRESS
    netmask $NETMASK
    gateway $GATEWAY
    dns-nameservers 8.8.8.8 8.8.4.4
EOF

echo -e "${GREEN}[✓] IP configurée: $IP_ADDRESS${NC}"

echo -e "${YELLOW}[*] Redémarrage du réseau...${NC}"
/etc/init.d/networking restart 2>/dev/null || ifdown eth0 && ifup eth0

echo -e "${YELLOW}[*] Vérification des services vulnérables...${NC}"

# Liste des services à vérifier
services=(
    "vsftpd:21:FTP"
    "ssh:22:SSH"
    "telnetd:23:Telnet"
    "apache2:80:HTTP"
    "smbd:139,445:SMB"
    "mysql:3306:MySQL"
    "postgresql:5432:PostgreSQL"
    "tomcat6:8180:Tomcat"
)

for service_info in "${services[@]}"; do
    IFS=':' read -r service port name <<< "$service_info"
    if systemctl is-active --quiet $service 2>/dev/null || service $service status 2>/dev/null | grep -q running; then
        echo -e "${GREEN}[✓] $name ($service) actif sur port $port${NC}"
    else
        echo -e "${YELLOW}[*] Démarrage de $name...${NC}"
        service $service start 2>/dev/null || systemctl start $service 2>/dev/null || echo -e "${RED}[!] Impossible de démarrer $service${NC}"
    fi
done

echo -e "${YELLOW}[*] Configuration FTP anonyme (vulnérable)...${NC}"
if [ -f /etc/vsftpd.conf ]; then
    cp /etc/vsftpd.conf /etc/vsftpd.conf.backup
    cat >> /etc/vsftpd.conf <<EOF

# Configuration vulnérable pour le lab
anonymous_enable=YES
write_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES
EOF
    service vsftpd restart
    echo -e "${GREEN}[✓] FTP anonyme activé${NC}"
fi

echo -e "${YELLOW}[*] Configuration SSH (vulnérable)...${NC}"
if [ -f /etc/ssh/sshd_config ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    service ssh restart
    echo -e "${GREEN}[✓] SSH configuré (PermitRootLogin activé)${NC}"
fi

echo -e "${YELLOW}[*] Création d'utilisateurs de test...${NC}"

# Utilisateurs avec mots de passe faibles (pour brute-force)
test_users=(
    "user:password"
    "admin:admin"
    "test:test123"
    "service:service"
)

for user_info in "${test_users[@]}"; do
    IFS=':' read -r username password <<< "$user_info"
    if ! id "$username" &>/dev/null; then
        useradd -m -s /bin/bash "$username"
        echo "$username:$password" | chpasswd
        echo -e "${GREEN}[✓] Utilisateur créé: $username (password: $password)${NC}"
    fi
done

echo -e "${YELLOW}[*] Configuration MySQL (vulnérable)...${NC}"
if command -v mysql &> /dev/null; then
    # Créer un utilisateur MySQL sans mot de passe
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS testdb;
CREATE USER IF NOT EXISTS 'testuser'@'%' IDENTIFIED BY 'testpass';
GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'%';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
    echo -e "${GREEN}[✓] MySQL configuré (accès distant activé)${NC}"
fi

echo -e "${YELLOW}[*] Création de fichiers sensibles...${NC}"

# Fichiers contenant des informations sensibles
mkdir -p /var/www/html/admin
cat > /var/www/html/admin/config.php <<'EOF'
<?php
// Configuration de la base de données
$db_host = "localhost";
$db_user = "root";
$db_pass = "root";
$db_name = "testdb";

// Clés secrètes
$api_key = "sk_test_4eC39HqLyjWDarjtT1zdp7dc";
$admin_password = "admin123";
?>
EOF

cat > /var/www/html/robots.txt <<EOF
User-agent: *
Disallow: /admin/
Disallow: /backup/
Disallow: /config/
Disallow: /private/
EOF

mkdir -p /var/www/html/backup
echo "username:admin" > /var/www/html/backup/credentials.txt
echo "password:P@ssw0rd123" >> /var/www/html/backup/credentials.txt

chmod 777 /var/www/html/backup
chmod 644 /var/www/html/backup/credentials.txt

echo -e "${GREEN}[✓] Fichiers sensibles créés${NC}"

echo -e "${YELLOW}[*] Désactivation du firewall...${NC}"
ufw disable 2>/dev/null || iptables -F
echo -e "${GREEN}[✓] Firewall désactivé${NC}"

echo -e "${YELLOW}[*] Génération du rapport de configuration...${NC}"
cat > /root/metasploitable-info.txt <<EOF
========================================
METASPLOITABLE - CONFIGURATION DU LAB
========================================

Adresse IP: $IP_ADDRESS
Masque: $NETMASK
Passerelle: $GATEWAY

SERVICES ACTIFS:
----------------
FTP (21)       : vsftpd (anonymous login enabled)
SSH (22)       : OpenSSH (root login enabled)
Telnet (23)    : telnetd
HTTP (80)      : Apache 2
SMB (139,445)  : Samba
MySQL (3306)   : MySQL Server
PostgreSQL (5432): PostgreSQL
Tomcat (8180)  : Apache Tomcat

COMPTES UTILISATEURS:
--------------------
root:root
msfadmin:msfadmin
user:password
admin:admin
test:test123
service:service

BASES DE DONNÉES:
-----------------
MySQL:
  - root/root (accès distant activé)
  - testuser/testpass

FICHIERS SENSIBLES:
-------------------
/var/www/html/admin/config.php
/var/www/html/backup/credentials.txt
/var/www/html/robots.txt

VULNÉRABILITÉS CONNUES:
----------------------
- FTP Anonymous Login
- SSH Root Login
- Weak passwords
- SQL Injection (vulnérabilités diverses)
- Directory Traversal
- Remote Code Execution
- Privilege Escalation

RECOMMANDATIONS:
----------------
⚠️  NE JAMAIS exposer cette machine à Internet
⚠️  Utiliser UNIQUEMENT dans un réseau isolé
⚠️  Arrêter après utilisation

========================================
EOF

cat /root/metasploitable-info.txt

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}[✓] Configuration terminée!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Informations de connexion sauvegardées dans:${NC}"
echo "  /root/metasploitable-info.txt"
echo ""
echo -e "${YELLOW}Connexions SSH de test:${NC}"
echo "  ssh msfadmin@$IP_ADDRESS (password: msfadmin)"
echo "  ssh user@$IP_ADDRESS (password: password)"
echo ""
echo -e "${RED}⚠️  CETTE MACHINE EST VOLONTAIREMENT VULNÉRABLE${NC}"
echo -e "${RED}   N'exposez JAMAIS cette VM à un réseau de production!${NC}"
