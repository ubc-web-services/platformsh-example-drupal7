#!/bin/bash

cd /app/public/sites/default/behat
export BEHAT_PARAMS='{"extensions" : {"Behat\\MinkExtension" : {"base_url" : "'"$1"'"}}}'
TAIL="$(bin/behat --tags="@Healthcheck" --format progress | tail -n 3)"
OUTPUT="$(echo "$TAIL")"
if [[ $OUTPUT == *"failed"* ]]; then
curl -X POST --data-urlencode "payload={'channel': '#platformsh', 'username': 'Behat Bot', 'icon_emoji': ':postbox:', 'attachments':[{'color':'danger', 'text': '*Target Website*: $1 \n *Target Environment*: $2 \n *Target Branch*: $3 \n *Result*: \n ${OUTPUT}'}]}" https://hooks.slack.com/services/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
else
curl -X POST --data-urlencode "payload={'channel': '#platformsh', 'username': 'Behat Bot', 'icon_emoji': ':postbox:', 'attachments':[{'color':'good', 'text': '*Target Website*: $1 \n *Target Environment*: $2 \n *Target Branch*: $3 \n *Result*: \n ${OUTPUT}'}]}" https://hooks.slack.com/services/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
fi
