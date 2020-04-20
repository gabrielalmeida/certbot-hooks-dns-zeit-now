#! /bin/bash

# Zeit Now API_KEY and TEAM_ID
# API_KEY="XXXXX"
# TEAM_ID="team_XXXXX"

# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
SUBDOMAIN=${CERTBOT_DOMAIN%%.*}

CREATE_DOMAIN="_acme-challenge.$SUBDOMAIN"
echo ">>>>>>> DOMAIN: $DOMAIN"
echo ">>>>>>> CREATE DOMAIN: $CREATE_DOMAIN"
echo ">>>>>>> CERTBOT VALIDATION: $CERTBOT_VALIDATION"

RESULT=$(curl -s -X POST "https://api.zeit.co/v2/domains/$DOMAIN/records?teamId=${TEAM_ID}" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{  "name": "'"$CREATE_DOMAIN"'",  "type": "TXT",  "value": "'"$CERTBOT_VALIDATION"'" }')

echo ">>>>>>> API RESPONSE: $RESULT"

RECORD_ID=$(echo $RESULT | python -c "import sys,json;print(json.load(sys.stdin)['uid'])")

# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi

echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID

# Sleep to make sure the change has time to propagate over to DNS
sleep 25
