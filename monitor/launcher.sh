#!/bin/bash

# Global variables
enum_subs="subs_enum"
subs="subdomains"

# Load scripts functions
source scripts/telegram_notify.sh

# For every program in programs to monitor get the scope and scan the subdomains
while read -r program; do
	# Get the scope for every program we are monitoring
	"scripts/get_public_program" "${program}"
	
	# Go to each program and enumerate subdomains
	cd "${program}"
	# If the subs_enum exists enumerate subdomains
	if [[ -f "${enum_subs}" ]]; then
		# If subdomains file exists make a backup
		if [[ -f "${subs}" ]]; then
			mv "${subs}" "${subs}.bak"
		fi
		cat "${enum_subs}" | xargs -I{} "../scripts/recon.sh" {}
	fi
done < config/programs

if [[ -f "${subs}.bak" ]]; then
	diff_subs=$(diff <(sort -u "${subs}.bak") <(sort -u "${subs}") | grep '>' | awk '{print $2}')
	if [[ "${diff_subs}" ]]; then
		sendMessage "${diff_subs}"
		echo "${diff_subs}" > new_subs
	fi
fi
