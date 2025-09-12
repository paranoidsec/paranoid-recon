# Paranoid Recon — Subdomain Enumeration

**Paranoid Security & Dark OSINT - Linux-first offensive workflows**

This repository contains a opinionated script to automate subdomain enumeration and quick host filtering.
It’s intended as a building block for recon during bug bounty, pentest, red team prep, or OSINT infrastructure mapping.

> **Use only on targets you are authorized to test.**
> Do not run this tool against hosts/domains that are out-of-scope or without permission.

---

## Features

- Enumerates subdomains using multiple tools
- *Work in progress*
  - Filter alive hosts
  - Automate looking for web applications/services
  - Produces output files ready for follow-up scanning

---

## Requirements

Install the following tools:
- [assetfinder](https://github.com/tomnomnom/assetfinder)
- [subfinder](https://github.com/projectdiscovery/subfinder)
- [censys](https://censys-python.readthedocs.io/en/stable/quick-start.html)
- [massdns](https://github.com/blechschmidt/massdns)
- [anew](https://github.com/tomnomnom/anew)
- [jq](https://jqlang.org/)
- [openssl](https://www.openssl.org/)
- [curl](https://curl.se/docs/manpage.html)

On many Linux distros:

```bash
# For the go tools
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# Install from the official repositories of your Linux distribution
sudo apt install curl
```

## Usage

```bash
chmod +x recon.sh
# Enumerate subdomains for one domain only
./recon.sh example.com
# Enumerate subdomains for a list of domains
cat domains | xargs -I{} -P1 ./recon.sh {}
```

### Example

```bash
./recon.sh hackerone.com
```

It create the following files:
- `subdomains` with all the domains and sub-domains found
- `massdns_${domain_name}` with the DNS resolution for all the subdomains found for a particular domain
- `netname` with the information discovered from censys about the certificate
- `SPF` with the IPs or domains discovered from the SPF DNS record

![Example output of the recon script](./images/sample_output.png)

*Screenshot is sanitized and for demonstration only — no live targets or PII.*
