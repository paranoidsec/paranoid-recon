# Scope Monitor (YesWeHack-customized)

This is a monitoring subsystem designed to automate recon for **YesWeHack bug bounty scopes**.

## What it does

1. Reads targets from `config/programs.txt`
2. Runs subdomain enumeration with [recon.sh](../recon.sh) via symbolic link
3. Store the results on the `subdomains` file and compares with the previous scan
4. Computes deltas -> store the new subdomains on the `newhosts`
5. (Optional) Sends alerts via Telegram bot

## Notes

- ⚠️ Currently optimized for YesWeHack platform scopes.  
- Adaptation needed for other platforms (HackerOne, Intigriti, etc.).  
- Use responsibly: only on scopes you are authorized to monitor.  

**Note**: The monitor uses a symbolic link to `../recon.sh`.
On Windows, clone with `git clone -c core.symlinks=true ...` or replace with a copy of `recon.sh`.

## Quick start

Get the programs you want to monitor from **YesWeHack** and store it on `config/programs.txt`.

```bash
cd monitor
chmod +x launcher.sh scripts/*.sh
./launcher.sh
```
