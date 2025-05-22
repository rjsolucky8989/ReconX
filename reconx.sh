#!/bin/bash

# ─────────────────────────────────────────────────────────────
# RECONX - Modern Red Team Recon Tool (Automated + Interactive)
# Author: Rushi Solanki | Cyber Security Analyst
# ─────────────────────────────────────────────────────────────

set -euo pipefail
IFS=$'\n\t'

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner function
function banner() {
  cat << "EOF"

██████╗ ███████╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗██╗  ██╗
██╔══██╗██╔════╝██╔════╝██╔═══██╗██╔═══██╗████╗  ██║██║ ██╔╝
██████╔╝█████╗  ██║     ██║   ██║██║   ██║██╔██╗ ██║█████╔╝ 
████╔═══██╔══╝  ██║     ██║   ██║██║   ██║██║╚██╗██║██╔═██╗ 
██║ ██  ███████╗╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║██║  ██╗
╚═╝ ╚═╝ ╚══════╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝

             [ RECONX - Red Team Recon Suite ]
                Author: Rushi Solanki
EOF
}

banner

# Check dependencies
REQUIRED_TOOLS=(whois subfinder dnsrecon dig httpx nuclei nmap feroxbuster)

echo -e "${CYAN}[+] Checking dependencies...${NC}"
for tool in "${REQUIRED_TOOLS[@]}"; do
  if ! command -v "$tool" &> /dev/null; then
    echo -e "${RED}[!] Required tool not found: $tool${NC}"
    exit 1
  fi
done
echo -e "${GREEN}[✓] All dependencies found.${NC}"

# Accept target IP or domain from argument or prompt user
if [[ $# -eq 1 ]]; then
  TARGET=$1
else
  read -rp $'\nEnter target IP or domain: ' TARGET
fi

# Create output directory
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
OUTDIR="results/${TARGET}-${TIMESTAMP}"
mkdir -p "$OUTDIR"

# Define recon steps as associative array
declare -A STEPS=(
  [1]="whois $TARGET"
  [2]="subfinder -d $TARGET -silent"
  [3]="dnsrecon -d $TARGET -t brt"
  [4]="dig $TARGET ANY +noall +answer"
  [5]="httpx -u https://$TARGET -status-code -tech-detect"
  [6]="nuclei -u https://$TARGET -severity critical,high,medium"
  [7]="nmap -T4 -A -sV -Pn $TARGET"
  [8]="nmap -T4 --script vuln $TARGET"
  [9]="nmap -T4 --script http-enum,smtp-enum-users $TARGET"
  [10]="nmap -T4 --script firewall-bypass $TARGET"
  [11]="nmap -T4 --script ssl-enum-ciphers $TARGET"
  [12]="feroxbuster -u https://$TARGET -C 403,404"
)

# Display interactive menu
function menu() {
  echo -e "${CYAN}\nSelect scan modules to run:${NC}"
  for i in {1..12}; do
    echo "$i) ${STEPS[$i]%% *}"
  done
  echo "A) Run ALL"
  echo "Q) Quit"
}

# Run selected step
function run_step() {
  local ID=$1
  local CMD="${STEPS[$ID]}"
  local CMD_NAME=$(echo "$CMD" | cut -d ' ' -f1)
  local OUTFILE="$OUTDIR/${ID}_${CMD_NAME}_output.txt"
  echo -e "\n${CYAN}[+] Running: $CMD${NC}"
  echo "[COMMAND] $CMD" | tee "$OUTFILE"
  eval "$CMD" 2>&1 | tee -a "$OUTFILE"
  echo -e "${GREEN}[✓] Output saved: $OUTFILE${NC}"
}

# User selection loop
while true; do
  menu
  read -rp $'\nEnter option (e.g. 1 5 8 or A): ' SELECTION

  if [[ "$SELECTION" =~ ^[Aa]$ ]]; then
    for i in {1..12}; do run_step "$i"; done
    break
  elif [[ "$SELECTION" =~ ^[Qq]$ ]]; then
    echo "Exiting..."
    exit 0
  else
    for CHOICE in $SELECTION; do
      if [[ ${STEPS[$CHOICE]+_} ]]; then
        run_step "$CHOICE"
      else
        echo -e "${RED}Invalid option: $CHOICE${NC}"
      fi
    done
  fi
done

echo -e "\n${GREEN}All selected scans completed.${NC}"
echo "Output directory: $OUTDIR"
