#!/bin/bash

# ============================================
# Script d'installation et configuration Kali Linux
# Pour Lab de Cybersécurité
# ============================================

set -e  # Arrêter en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installation Kali Linux - Lab Cyber${NC}"
echo -e "${GREEN}========================================${NC}"

# Vérification des privilèges root
if [ "$EUID" -ne 0 ]; then 
   echo -e "${RED}[!] Ce script doit être exécuté en tant que root${NC}"
   exit 1
fi

echo -e "${YELLOW}[*] Mise à jour du système...${NC}"
apt-get update -qq
apt-get upgrade -y -qq

echo -e "${YELLOW}[*] Installation des outils de reconnaissance...${NC}"
apt-get install -y -qq \
    nmap \
    netdiscover \
    masscan \
    recon-ng \
    theHarvester \
    maltego \
    fierce \
    dnsenum \
    dnsrecon

echo -e "${YELLOW}[*] Installation des outils de scan web...${NC}"
apt-get install -y -qq \
    nikto \
    dirb \
    gobuster \
    wfuzz \
    wpscan \
    whatweb \
    wafw00f

echo -e "${YELLOW}[*] Installation des outils d'exploitation...${NC}"
apt-get install -y -qq \
    metasploit-framework \
    sqlmap \
    exploitdb \
    crackmapexec \
    responder \
    enum4linux \
    smbclient \
    impacket-scripts

echo -e "${YELLOW}[*] Installation des outils de cracking...${NC}"
apt-get install -y -qq \
    john \
    hashcat \
    hydra \
    medusa \
    patator \
    cewl

echo -e "${YELLOW}[*] Installation des outils réseau...${NC}"
apt-get install -y -qq \
    wireshark \
    tcpdump \
    netcat-openbsd \
    socat \
    proxychains4 \
    tor \
    openvpn

echo -e "${YELLOW}[*] Installation des outils de post-exploitation...${NC}"
apt-get install -y -qq \
    mimikatz \
    powershell \
    powersploit \
    windows-binaries

echo -e "${YELLOW}[*] Installation des utilitaires...${NC}"
apt-get install -y -qq \
    git \
    curl \
    wget \
    vim \
    tmux \
    screen \
    python3-pip \
    python3-venv \
    docker.io \
    docker-compose

echo -e "${YELLOW}[*] Configuration de Metasploit...${NC}"
systemctl start postgresql
systemctl enable postgresql
msfdb init

echo -e "${YELLOW}[*] Installation d'outils Python additionnels...${NC}"
pip3 install --quiet \
    requests \
    beautifulsoup4 \
    pwntools \
    scapy \
    impacket

echo -e "${YELLOW}[*] Configuration du réseau...${NC}"

# Activer le forwarding IP
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Configuration de proxychains
sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains4.conf
sed -i 's/#dynamic_chain/dynamic_chain/' /etc/proxychains4.conf

echo -e "${YELLOW}[*] Création de la structure de dossiers...${NC}"
mkdir -p ~/lab/{recon,exploit,loot,reports,scripts}

echo -e "${YELLOW}[*] Téléchargement de wordlists...${NC}"
if [ ! -d "/usr/share/wordlists/SecLists" ]; then
    cd /usr/share/wordlists
    git clone --quiet https://github.com/danielmiessler/SecLists.git
    cd -
fi

echo -e "${YELLOW}[*] Configuration de aliases utiles...${NC}"
cat >> ~/.bashrc <<'EOF'

# Aliases pour le lab
alias ll='ls -alh'
alias nse='ls /usr/share/nmap/scripts/ | grep'
alias msf='msfconsole -q'
alias scan-quick='nmap -T4 -F'
alias scan-full='nmap -T4 -A -v'
alias web-scan='nikto -h'
alias http-server='python3 -m http.server 8000'
alias reverse-shell='nc -lvnp 4444'

# Fonction pour scanner un réseau
function scan-network() {
    if [ -z "$1" ]; then
        echo "Usage: scan-network <network/CIDR>"
        return 1
    fi
    nmap -sn $1 -oG - | grep "Up" | cut -d' ' -f2
}

# Fonction pour lancer une attaque brute-force SSH
function brute-ssh() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: brute-ssh <target> <userlist>"
        return 1
    fi
    hydra -L $2 -P /usr/share/wordlists/rockyou.txt $1 ssh
}
EOF

echo -e "${YELLOW}[*] Création de scripts utiles...${NC}"

# Script de scan rapide
cat > ~/lab/scripts/quick-scan.sh <<'SCRIPT'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

echo "[*] Scan rapide de $1"
echo "[*] Découverte de ports..."
nmap -T4 -F $1

echo ""
echo "[*] Détection de services..."
nmap -sV -T4 -p- --top-ports 100 $1
SCRIPT

chmod +x ~/lab/scripts/quick-scan.sh

# Script de préparation d'attaque web
cat > ~/lab/scripts/web-recon.sh <<'SCRIPT'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

TARGET=$1
OUTPUT_DIR=~/lab/recon/$(echo $TARGET | sed 's/https\?:\/\///' | tr '/' '_')
mkdir -p $OUTPUT_DIR

echo "[*] Reconnaissance web de $TARGET"
echo "[*] Résultats dans: $OUTPUT_DIR"

echo "[*] Scan Nikto..."
nikto -h $TARGET -o $OUTPUT_DIR/nikto.txt

echo "[*] Énumération de répertoires..."
gobuster dir -u $TARGET -w /usr/share/wordlists/dirb/common.txt -o $OUTPUT_DIR/gobuster.txt

echo "[*] Détection de technologies..."
whatweb $TARGET > $OUTPUT_DIR/whatweb.txt

echo "[*] Scan terminé!"
SCRIPT

chmod +x ~/lab/scripts/web-recon.sh

echo -e "${YELLOW}[*] Création du template de rapport...${NC}"
cat > ~/lab/reports/template.md <<'TEMPLATE'
# Rapport de Test de Pénétration

## Informations Générales
- **Date**: 
- **Testeur**: 
- **Cible**: 
- **Scope**: 

## 1. Résumé Exécutif

## 2. Méthodologie

## 3. Reconnaissance
### 3.1 Découverte de l'hôte
### 3.2 Scan de ports
### 3.3 Énumération des services

## 4. Vulnérabilités Identifiées
### 4.1 Vulnérabilité #1
- **Sévérité**: 
- **Description**: 
- **Preuve de concept**: 
- **Impact**: 
- **Recommandation**: 

## 5. Exploitation

## 6. Post-exploitation

## 7. Recommandations

## 8. Conclusion
TEMPLATE

echo -e "${YELLOW}[*] Configuration des services...${NC}"

# Démarrer Docker
systemctl start docker
systemctl enable docker

# Ajouter l'utilisateur au groupe docker
usermod -aG docker kali 2>/dev/null || true

echo -e "${YELLOW}[*] Nettoyage...${NC}"
apt-get autoremove -y -qq
apt-get clean

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}[✓] Installation terminée avec succès!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Outils installés:${NC}"
echo "  - Reconnaissance: nmap, netdiscover, recon-ng, theHarvester"
echo "  - Web: nikto, gobuster, sqlmap, wpscan"
echo "  - Exploitation: metasploit, exploitdb, crackmapexec"
echo "  - Cracking: john, hashcat, hydra"
echo "  - Réseau: wireshark, tcpdump, netcat"
echo ""
echo -e "${YELLOW}Structure créée:${NC}"
echo "  ~/lab/recon     - Résultats de reconnaissance"
echo "  ~/lab/exploit   - Scripts d'exploitation"
echo "  ~/lab/loot      - Données récupérées"
echo "  ~/lab/reports   - Rapports de test"
echo "  ~/lab/scripts   - Scripts utiles"
echo ""
echo -e "${YELLOW}Scripts disponibles:${NC}"
echo "  ~/lab/scripts/quick-scan.sh <target>"
echo "  ~/lab/scripts/web-recon.sh <url>"
echo ""
echo -e "${YELLOW}Commandes utiles:${NC}"
echo "  msf                 - Lancer Metasploit"
echo "  scan-quick <ip>     - Scan rapide"
echo "  scan-network <cidr> - Scanner un réseau"
echo ""
echo -e "${GREEN}Rechargez le shell: source ~/.bashrc${NC}"
echo ""
echo -e "${RED}⚠️  RAPPEL: Utilisez ces outils UNIQUEMENT dans un environnement de lab!${NC}"
