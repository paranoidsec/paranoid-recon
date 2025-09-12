#!/bin/bash

domain="$1"

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <domain>"
	exit 1
fi

# Subdomains
## Create the file subdomains if it doesn't exists
touch subdomains

## Enumerate subdomains with assetfinder and subfinder
echo "$domain" | assetfinder --subs-only | anew subdomains
subfinder -silent -d "$domain" -all -m "$domain" | anew subdomains

## Get more subdomains from crt.sh
curl -s "https://crt.sh/json?q=$domain" | jq -r '.[].common_name' | sort -u | anew subdomains

## Use censys cli to retrieve subdomains
censys subdomains "$domain" | grep '-' | awk '{print $2}' | anew subdomains

## Use rapiddns to get more subdomains
curl -s --compressed "https://rapiddns.io/subdomain/$domain?full=1" \
  | grep "^<td>" | grep "$domain" | grep -v target | sed -e 's/<td>//g' -e 's/<\/td>//g' | sort -u | anew subdomains

## Get subdomains from alternative names
sed -ne 's/^\( *\)Subject:/\1/p;/X509v3 Subject Alternative Name/{
    N;s/^.*\n//;:a;s/^\( *\)\(.*\), /\1\2\n\1/;ta;p;q; }' < <(
    openssl x509 -noout -text -in <(
        openssl s_client -ign_eof 2>/dev/null <<<$'HEAD / HTTP/1.0\r\n\r' \
            -connect $domain:443 ) ) | grep "DNS" | awk -F':' '{print $2}' | grep "$domain" | anew subdomains

# Netname
## Create the file it doesn't exists
touch netname
## Use censys to get netname
censys search "services.tls.certificate.parsed.subject.organization: $domain" | jq -r '.[].ip' | xargs -I{} bash -c 'printf "{} - "; whois {} | grep netname' > netname

# Massdns
## Resolve domains with massdns
massdns -r /home/artic/Documents/BugBounty/dictionaries/resolvers.txt -t A -q -o S -w massdns_"$domain" < subdomains

# SPF
touch SPF
## Get IPs or subdomains from SPF
dig +short TXT "$domain" | grep spf | sed 's/ /\n/g' | grep 'ip' | awk -F':' '{print $2}' >> SPF
