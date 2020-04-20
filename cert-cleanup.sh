#!/bin/bash

# Zeit Now API_KEY and TEAM_ID
# API_KEY="XXXXX"
# TEAM_ID="team_XXXXX"

# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID ]; then
        RECORD_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID)
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
fi

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_ID}" ]; then
curl -s -X DELETE "https://api.zeit.co/v2/domains/$DOMAIN/records/$RECORD_ID?teamId=$TEAM_ID" \
  -H "Authorization: Bearer $API_KEY"
fi
