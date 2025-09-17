#!/bin/bash

# Load API keys
source config/telegram.env

# Telegram functions

# Send messages
function sendMessage {
	curl -s -X POST \
		-H 'Content-Type: application/json' \
		-d "{\"chat_id\": $chatID, \"text\": \"$1\", \"disable_notification\": true}" \
		"https://api.telegram.org/bot$botAPIKey/sendMessage?&parse_mode=Markdown" > /dev/null
}

# Send documents
function sendDocument {
	curl -s -F "chat_id=$chatID" -F document="@$1" "https://api.telegram.org/bot$botAPIKey/sendDocument" > /dev/null
}

# Get information about the groups and channels
function getUpdates {
	curl -sX GET "https://api.telegram.org/bot$botAPIKey/getUpdates"
}

# Get information about the bot
function getMe {
	curl -sX POST "https://api.telegram.org/bot$botAPIKey/getMe"
}
