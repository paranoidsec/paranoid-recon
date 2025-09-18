#!/bin/bash

# Get all the subdomains for a particular domain
domain="$1"

# Subdomains
## Create the file subdomains if it doesn't exists
touch subdomains

## Enumerate subdomains with assetfinder and subfinder
echo "$domain" | assetfinder --subs-only | anew subdomains
subfinder -silent -d "$domain" -all -recursive | anew subdomains

## Get more subdomains from crt.sh
curl -s "https://crt.sh/json?q=$domain" | jq -r '.[].common_name' | sort -u | anew subdomains

## Use censys cli to retrieve subdomains
#censys subdomains "$domain" | grep '-' | awk '{print $2}' | anew subdomains

## Use rapiddns to get more subdomains
curl -s --compressed "https://rapiddns.io/subdomain/$domain?full=1" \
  | grep "^<td>" | grep "$domain" | grep -v target | sed -e 's/<td>//g' -e 's/<\/td>//g' | sort -u | anew subdomains

## Get subdomains from alternative names
sed -ne 's/^\( *\)Subject:/\1/p;/X509v3 Subject Alternative Name/{
    N;s/^.*\n//;:a;s/^\( *\)\(.*\), /\1\2\n\1/;ta;p;q; }' < <(
    openssl x509 -noout -text -in <(
        openssl s_client -ign_eof 2>/dev/null <<<$'HEAD / HTTP/1.0\r\n\r' \
            -connect $domain:443 ) ) | grep "DNS" | awk -F':' '{print $2}' | anew subdomains

chaos -silent -d "$domain" | anew subdomains

## Sanitize the subdomains file with only the scope
grep -Ev $(cat subs_enum | tr '\n' '|' | sed 's/|$//') subdomains |\
	xargs -I{} -P1 sed -i '/{}/d' subdomains
