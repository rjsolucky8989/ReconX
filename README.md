<!-- README for ReconX -->
<h1 align="center">
  <img src="https://raw.githubusercontent.com/your-user/reconx/main/.assets/reconx_banner.svg" width="600" alt="ReconX">
  <br>
  ReconX&nbsp;·&nbsp;Red Team Recon Suite
</h1>

<p align="center">
  <a href="https://github.com/your-user/reconx/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/your-user/reconx/shellcheck.yml?label=test&logo=github" alt="build-status">
  </a>
  <a href="https://github.com/your-user/reconx/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/your-user/reconx" alt="license">
  </a>
  <img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg" alt="bash">
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs">
</p>

> **ReconX** is an **automated + interactive** reconnaissance toolkit for red-teamers and bug-bounty hunters.  
> Run targeted, menu-driven scans—WHOIS, Subdomain Enum, DNS bruteforce, HTTP tech-detect, Nuclei scans, Nmap service/vuln sweeps, `feroxbuster` directory brute-force—and neatly collect everything into time‑stamped folders.

---

## ✨ Features

| Module | Tool used | Purpose |
|:--|:--|:--|
| WHOIS | `whois` | Domain registry intel |
| Sub-domain enum | `subfinder` | Asset discovery |
| DNS brute | `dnsrecon` | Record harvesting |
| DNS records | `dig` | Quick ANY lookup |
| Tech & status | `httpx` | Detect frameworks, response codes |
| Vulnerability scan | `nuclei` | Critical→medium templates |
| Port & service scan | `nmap -sV -A` | Service/version detection |
| Vuln NSE set | `nmap --script vuln` | Common CVEs 🛑 |
| HTTP/SMTP enum | `nmap --script http-enum,smtp-enum-users` | Surface dirs & users |
| Firewall bypass tests | `nmap --script firewall-bypass` | Egress testing |
| SSL cipher scan | `nmap --script ssl-enum-ciphers` | Weak crypto check |
| Dir brute | `feroxbuster` | 403/404-aware directory fuzzing |

---

## 🛠 Requirements

* **Bash 4+** (Unix/Linux/macOS/WSL)
* Tools in `$PATH`: `whois subfinder dnsrecon dig httpx nuclei nmap feroxbuster`  

```bash
# Debian/Ubuntu quick install
sudo apt update && sudo apt install whois dnsrecon dnsutils nmap feroxbuster -y
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```
* **Internet connection** for external look-ups.

---

## 🚀 Installation

```bash
git clone https://github.com/your-user/reconx.git
cd reconx
chmod +x reconx.sh        # one-time
```

---

## ▶️ Usage

```bash
# Quick scan (prompt mode)
./reconx.sh

# One-liner against example.com
./reconx.sh example.com
```

You’ll be presented with a menu:

```
Select scan modules to run:
1) whois        5) httpx        9) nmap http-enum
2) subfinder    6) nuclei      10) nmap firewall-bypass
3) dnsrecon     7) nmap-sV     11) nmap ssl-ciphers
4) dig          8) nmap vuln   12) feroxbuster
A) Run ALL      Q) Quit
```

Outputs land in `results/<TARGET>-<TIMESTAMP>/`.

---

## 🖼 Demo

![demo-gif](.assets/demo.gif)

---

## 🤝 Contributing

PRs are welcome!  

1. Fork → create feature branch → commit → open PR.  
2. Please run `shellcheck reconx.sh` before pushing.  
3. For bigger changes, open an issue first to discuss what you want to change.

---

## 📄 License

Released under the **MIT License**—see [`LICENSE`](LICENSE) for details.

---

> *Crafted with ❤️ by Rushi Solanki — stay curious, stay secure!*
