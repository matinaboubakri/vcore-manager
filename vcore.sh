#!/bin/bash

# =================================================================
# Project: V-CORE MANAGER (Final Bug-Free Release)
# Supported OS: Ubuntu 20.04 / 22.04 / 24.04
# =================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Root Check
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Please run as root${NC}"
   exit 1
fi

# Fixed Geo Info (Fast & Stable)
get_geo_info() {
    local info=$(curl -s --max-time 5 https://ipinfo.io)
    IP=$(echo "$info" | grep -oP '(?<="ip": ")[^"]*' || curl -s ifconfig.me)
    CITY=$(echo "$info" | grep -oP '(?<="city": ")[^"]*' || echo "Unknown")
    COUNTRY=$(echo "$info" | grep -oP '(?<="country": ")[^"]*' || echo "Unknown")
}

# 1. Live Monitor (Standard & Interactive)
live_monitor() {
    clear
    echo -e "${YELLOW}V-CORE LIVE STATUS (Press 'q' to Exit)${NC}"
    echo "----------------------------------------------"
    sleep 1
    top -d 1
}

# 2. Fixed Open Ports (Clean Column Formatting)
show_open_ports() {
    clear
    echo -e "${CYAN}--- ACTIVE OPEN PORTS & SERVICES ---${NC}"
    echo "---------------------------------------------------"
    printf "${BOLD}%-10s %-20s %-10s${NC}\n" "PORT" "SERVICE" "PROTO"
    
    # Using 'ss' with clean parsing to avoid 'systemd' clutter
    ss -tulnp | grep LISTEN | awk '{
        split($5, a, ":"); 
        port=a[length(a)]; 
        split($7, b, ","); 
        split(b[1], c, "="); 
        service=c[2]; 
        gsub(/"/, "", service);
        if (service == "") service="Unknown";
        printf "%-10s %-20s %-10s\n", port, service, $1
    }' | sort -un
    
    echo "---------------------------------------------------"
}

# 3. Connected Clients
show_connections() {
    clear
    echo -e "${CYAN}--- ESTABLISHED CONNECTIONS ---${NC}"
    echo "----------------------------------------------"
    printf "${BOLD}%-5s %-25s${NC}\n" "COUNT" "REMOTE IP"
    ss -tun | grep ESTAB | awk '{split($6, a, ":"); print a[1]}' | sort | uniq -c | sort -nr
    echo "----------------------------------------------"
}

# Header Specs
show_specs() {
    clear
    echo -e "${CYAN}  __     __      _____  ____  _____  ______ "
    echo "  \ \   / /     / ____|/ __ \|  __ \|  ____|"
    echo "   \ \_/ /_____| |    | |  | | |__) | |__   "
    echo "    \   /______| |    | |  | |  _  /|  __|  "
    echo "     | |       | |____| |__| | | \ \| |____ "
    echo "     |_|        \_____|\____/|_|  \_\______|"
    echo -e "${NC}"
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${BLUE}OS :${NC} $(lsb_release -ds)"
    echo -e "${BLUE}RAM:${NC} $(free -h | awk '/^Mem:/ {print $2}')"
    echo -e "${BLUE}CPU:${NC} $(nproc) Cores"
    echo -e "${CYAN}------------------------------------------${NC}"
    echo -e "${YELLOW}IP :${NC} $IP | ${YELLOW}Loc:${NC} $CITY, $COUNTRY"
    echo -e "${CYAN}==========================================${NC}"
}

# Start Logic
get_geo_info
while true; do
    show_specs
    echo -e "1) Live Monitor (Real-time)"
    echo -e "2) Show Open Ports (Services)"
    echo -e "3) Show Connected Clients (IPs)"
    echo -e "4) System Optimization (Clean/Update)"
    echo -e "5) Security (Enable Firewall)"
    echo -e "6) Install Docker (Engine/Compose)"
    echo -e "7) Exit"
    echo -en "\n${BOLD}Selection: ${NC}"
    read choice

    case $choice in
        1) live_monitor ;;
        2) show_open_ports ;;
        3) show_connections ;;
        4) 
            echo -e "${YELLOW}Cleaning logs and updating...${NC}"
            apt update && apt upgrade -y && apt autoremove -y
            journalctl --vacuum-time=1d
            ;;
        5) ufw allow 22/tcp && ufw --force enable ;;
        6) apt update && apt install -y docker.io docker-compose && systemctl enable --now docker ;;
        7) exit 0 ;;
        *) echo -e "${RED}Invalid!${NC}" ;;
    esac
    echo -e "\n${YELLOW}Press Enter to return...${NC}"
    read
done
