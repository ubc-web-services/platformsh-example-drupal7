#!/bin/bash

cd /app/public/sites/default/behat
export BEHAT_PARAMS='{"extensions" : {"Behat\\MinkExtension" : {"base_url" : "'"$1"'"}}}'
OUTPUT="$(bin/behat --format progress)"
echo "${OUTPUT}"
curl -X POST --data-urlencode "payload={'channel': '#platformsh', 'username': 'Behat Bot', 'text': '*Target Website*: $1 \n *Target Environment*: $2 \n *Target Branch*: $3 \n *Result*: \n ${OUTPUT}', 'icon_emoji': ':postbox:'}" https://hooks.slack.com/services/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


