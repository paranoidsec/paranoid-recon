# Changelog

All notable changes to **paranoid-recon** will be documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

- Optional DNS brute-force mode (`--bruteforce`) [planned]

---

## [v0.3.1]

### Added

- Integrated ProjectDiscovery Chaos into `recon.sh` and `monitor/launcher.sh`
- Added comparison of subdomain runs → outputs only new assets (`newhosts`)

---

## [v0.3]

### Added

- New **scope monitor** (customized for YesWeHack scopes)
  - Enumerates subdomains with `recon.sh`
  - Compares results with the last run
  - Outputs only new subdomains (`newhosts`)

---

## [v0.2]

### Added

- Live-host filtering with `nmap`
- Focused nmap scan (`--top-ports 100`, `-sV`)
- Safer defaults (non-root fallback)

---

## [v0.1]

### Added

- Initial release with basic subdomain enumeration

