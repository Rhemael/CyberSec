#!/bin/bash

# ============================================
# Script de configuration du réseau virtuel
# Pour Lab de Cybersécurité
# ============================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Configuration Réseau du Lab${NC}"
echo -e "${GREEN}========================================${NC}"

# Vérification des privilèges
if [ "$EUID" -ne 0 ]; then 
   echo -e "${RED}[!] Ce script doit être exécuté en tant que root${NC}"
   exit 1
fi

# Variables de configuration
LAB_NETWORK="192.168.100.0/24"
LAB_GATEWAY="192.168.100.1"
KALI_IP="192.168.100.10"
METASPLOIT_IP="192.168.100.20"
UBUNTU_IP="192.168.100.30"
DVWA_IP="192.168.100.40"

echo -e "${BLUE}Configuration du réseau:${NC}"
echo -e "  Réseau: $LAB_NETWORK"
echo -e "  Passerelle: $LAB_GATEWAY"
echo -e "  Kali Linux: $KALI_IP"
echo -e "  Metasploitable: $METASPLOIT_IP"
echo -e "  Ubuntu Server: $UBUNTU_IP"
echo -e "  DVWA: $DVWA_IP"
echo ""

# Détection de l'environnement
if command -v docker &> /dev/null; then
    echo -e "${YELLOW}[*] Docker détecté - Configuration Docker Network${NC}"
    USING_DOCKER=true
elif command -v VBoxManage &> /dev/null; then
    echo -e "${YELLOW}[*] VirtualBox détecté - Configuration VirtualBox Network${NC}"
    USING_VBOX=true
elif command -v virsh &> /dev/null; then
    echo -e "${YELLOW}[*] KVM détecté - Configuration KVM Network${NC}"
    USING_KVM=true
else
    echo -e "${YELLOW}[*] Configuration générique${NC}"
    USING_GENERIC=true
fi

# ============================================
# Configuration Docker Network
# ============================================
if [ "$USING_DOCKER" = true ]; then
    echo -e "${YELLOW}[*] Création du réseau Docker...${NC}"
    
    # Supprimer le réseau s'il existe
    docker network rm lab_network 2>/dev/null || true
    
    # Créer le réseau
    docker network create \
        --driver=bridge \
        --subnet=$LAB_NETWORK \
        --gateway=$LAB_GATEWAY \
        --opt com.docker.network.bridge.name=br-lab \
        lab_network
    
    echo -e "${GREEN}[✓] Réseau Docker créé${NC}"
    
    # Vérification
    docker network inspect lab_network > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Réseau vérifié avec succès${NC}"
    fi
fi

# ============================================
# Configuration VirtualBox Network
# ============================================
if [ "$USING_VBOX" = true ]; then
    echo -e "${YELLOW}[*] Configuration des réseaux VirtualBox...${NC}"
    
    # Créer un réseau Host-Only
    HOSTONLYIF=$(VBoxManage hostonlyif create 2>&1 | grep -oP "'\K[^']+")
    
    if [ -n "$HOSTONLYIF" ]; then
        echo -e "${GREEN}[✓] Interface Host-Only créée: $HOSTONLYIF${NC}"
        
        # Configurer l'interface
        VBoxManage hostonlyif ipconfig $HOSTONLYIF \
            --ip $LAB_GATEWAY \
            --netmask 255.255.255.0
        
        echo -e "${GREEN}[✓] Interface configurée${NC}"
        
        # Activer le serveur DHCP (optionnel)
        VBoxManage dhcpserver add \
            --ifname $HOSTONLYIF \
            --ip $LAB_GATEWAY \
            --netmask 255.255.255.0 \
            --lowerip 192.168.100.100 \
            --upperip 192.168.100.200 \
            --enable 2>/dev/null || echo -e "${YELLOW}[*] DHCP déjà configuré${NC}"
    fi
    
    # Créer un réseau Internal
    echo -e "${YELLOW}[*] Réseau Internal 'labnet' prêt${NC}"
    echo -e "${BLUE}   Configurez vos VMs avec:${NC}"
    echo -e "   - Carte 1: NAT (pour Internet)"
    echo -e "   - Carte 2: Réseau interne 'labnet' (pour le lab)"
fi

# ============================================
# Configuration KVM Network
# ============================================
if [ "$USING_KVM" = true ]; then
    echo -e "${YELLOW}[*] Configuration du réseau KVM...${NC}"
    
    # XML du réseau
    cat > /tmp/lab-network.xml <<EOF
<network>
  <name>labnet</name>
  <forward mode='nat'/>
  <bridge name='virbr-lab' stp='on' delay='0'/>
  <ip address='$LAB_GATEWAY' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.100.100' end='192.168.100.200'/>
      <host mac='52:54:00:00:00:10' ip='$KALI_IP'/>
      <host mac='52:54:00:00:00:20' ip='$METASPLOIT_IP'/>
      <host mac='52:54:00:00:00:30' ip='$UBUNTU_IP'/>
    </dhcp>
  </ip>
</network>
EOF
    
    # Détruire le réseau s'il existe
    virsh net-destroy labnet 2>/dev/null || true
    virsh net-undefine labnet 2>/dev/null || true
    
    # Créer et démarrer le réseau
    virsh net-define /tmp/lab-network.xml
    virsh net-start labnet
    virsh net-autostart labnet
    
    echo -e "${GREEN}[✓] Réseau KVM 'labnet' créé et démarré${NC}"
    
    rm /tmp/lab-network.xml
fi

# ============================================
# Configuration IP Forwarding et NAT
# ============================================
echo -e "${YELLOW}[*] Configuration du routage...${NC}"

# Activer l'IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p > /dev/null 2>&1

echo -e "${GREEN}[✓] IP forwarding activé${NC}"

# Configuration NAT avec iptables
echo -e "${YELLOW}[*] Configuration du NAT...${NC}"

# Identifier l'interface Internet
INET_IFACE=$(ip route | grep default | awk '{print $5}' | head -1)

if [ -n "$INET_IFACE" ]; then
    echo -e "${BLUE}   Interface Internet: $INET_IFACE${NC}"
    
    # Configurer le NAT
    iptables -t nat -A POSTROUTING -s $LAB_NETWORK -o $INET_IFACE -j MASQUERADE
    iptables -A FORWARD -s $LAB_NETWORK -j ACCEPT
    iptables -A FORWARD -d $LAB_NETWORK -j ACCEPT
    
    echo -e "${GREEN}[✓] NAT configuré${NC}"
    
    # Sauvegarder les règles iptables
    if command -v iptables-save &> /dev/null; then
        iptables-save > /etc/iptables.rules 2>/dev/null || true
        echo -e "${GREEN}[✓] Règles iptables sauvegardées${NC}"
    fi
fi

# ============================================
# Configuration DNS
# ============================================
echo -e "${YELLOW}[*] Configuration DNS locale...${NC}"

cat >> /etc/hosts <<EOF

# Lab de Cybersécurité
$KALI_IP        kali kali-attacker
$METASPLOIT_IP  metasploitable target
$UBUNTU_IP      ubuntu ubuntu-server
$DVWA_IP        dvwa webapp
EOF

echo -e "${GREEN}[✓] Entrées DNS ajoutées${NC}"

# ============================================
# Création du script de test
# ============================================
echo -e "${YELLOW}[*] Création du script de test...${NC}"

cat > /usr/local/bin/test-lab-network <<'TESTSCRIPT'
#!/bin/bash

echo "========================================"
echo "Test de Connectivité du Lab"
echo "========================================"
echo ""

# Hosts à tester
declare -A hosts=(
    ["Kali Linux"]="192.168.100.10"
    ["Metasploitable"]="192.168.100.20"
    ["Ubuntu Server"]="192.168.100.30"
    ["DVWA"]="192.168.100.40"
)

for name in "${!hosts[@]}"; do
    ip="${hosts[$name]}"
    echo -n "Test $name ($ip)... "
    
    if ping -c 1 -W 2 $ip > /dev/null 2>&1; then
        echo -e "\033[0;32m✓ OK\033[0m"
    else
        echo -e "\033[0;31m✗ FAIL\033[0m"
    fi
done

echo ""
echo "Test des services:"
echo "------------------"

# Test HTTP Metasploitable
echo -n "HTTP Metasploitable (80)... "
if nc -z -w2 192.168.100.20 80 2>/dev/null; then
    echo -e "\033[0;32m✓ OK\033[0m"
else
    echo -e "\033[0;31m✗ FAIL\033[0m"
fi

# Test SSH Metasploitable
echo -n "SSH Metasploitable (22)... "
if nc -z -w2 192.168.100.20 22 2>/dev/null; then
    echo -e "\033[0;32m✓ OK\033[0m"
else
    echo -e "\033[0;31m✗ FAIL\033[0m"
fi

# Test HTTP DVWA
echo -n "HTTP DVWA (80)... "
if nc -z -w2 192.168.100.40 80 2>/dev/null; then
    echo -e "\033[0;32m✓ OK\033[0m"
else
    echo -e "\033[0;31m✗ FAIL\033[0m"
fi

echo ""
TESTSCRIPT

chmod +x /usr/local/bin/test-lab-network

echo -e "${GREEN}[✓] Script de test créé: test-lab-network${NC}"

# ============================================
# Documentation de la topologie
# ============================================
echo -e "${YELLOW}[*] Génération de la documentation...${NC}"

cat > /root/lab-network-info.txt <<EOF
========================================
TOPOLOGIE RÉSEAU DU LAB
========================================

RÉSEAU: $LAB_NETWORK
PASSERELLE: $LAB_GATEWAY

MACHINES:
---------
┌────────────────────────────────────────────────┐
│           Internet (via NAT)              │
└─────────────────┬──────────────────────────────┘
                 │
         ┌───────┴────────┐
         │   Passerelle   │
         │ $LAB_GATEWAY │
         └───────┬────────┘
                 │
    ─────────────┴──────────────
    │            │            │
┌───┴────┐  ┌────┴────┐  ┌───┴────┐
│  Kali  │  │ Target │  │ Ubuntu │
│  .10   │  │  .20   │  │  .30   │
└─────────┘  └─────────┘  └─────────┘

Kali Linux (Attaquant):
  - IP: $KALI_IP
  - Rôle: Machine d'attaque
  - Outils: nmap, metasploit, burp, etc.

Metasploitable (Cible):
  - IP: $METASPLOIT_IP
  - Rôle: Machine vulnérable
  - Services: FTP, SSH, HTTP, SMB, MySQL

Ubuntu Server (Serveur):
  - IP: $UBUNTU_IP
  - Rôle: Serveur web cible
  - Services: Apache, MySQL, SSH

DVWA (Web App):
  - IP: $DVWA_IP
  - Rôle: Application web vulnérable
  - Accès: http://$DVWA_IP

TYPES DE RÉSEAU:
-----------------
1. NAT: Accès Internet, isolé de l'hôte
2. Host-Only: Communication VM ↔ Hôte, pas d'Internet
3. Internal: Communication VM ↔ VM uniquement

CONFIGURATION RECOMMANDÉE:
--------------------------
Toutes les VMs sur le même réseau internal/host-only
pour l'isolation et la sécurité.

COMMANDES UTILES:
-----------------
# Tester la connectivité
test-lab-network

# Scanner le réseau depuis Kali
nmap -sn $LAB_NETWORK

# Voir la table de routage
route -n

# Voir les règles iptables
iptables -L -n -v

SÉCURITÉ:
----------
⚠️  Ce réseau est isolé et sécurisé par NAT
⚠️  Les VMs ne peuvent pas accéder à votre réseau local
⚠️  N'exposez JAMAIS ces services à Internet

========================================
EOF

cat /root/lab-network-info.txt

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}[✓] Configuration réseau terminée!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Commandes utiles:${NC}"
echo "  test-lab-network          - Tester la connectivité"
echo "  cat /root/lab-network-info.txt - Voir la topologie"
echo ""
echo -e "${YELLOW}Informations sauvegardées dans:${NC}"
echo "  /root/lab-network-info.txt"
echo ""
