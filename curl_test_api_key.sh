#!/bin/bash

source .env

set -euo pipefail

echo "♊️ Testing Gemini with simple curl and NANOBOTS_PAYLOAD with key=$GOOGLE_API_KEY"

NANOBOTS_PAYLOAD='{"contents":[{"role":"user","parts":{"text":"Hello"}}],"generationConfig":{"candidateCount":1},"system_instruction":{"role":"user","parts":{"text":"You a
re a helpful assistant."}}}'

#  -d '{"contents":[{"parts":[{"text":"Explain how AI works"}]}]}' \

curl \
  -H 'Content-Type: application/json' \
  -d "$NANOBOTS_PAYLOAD" \
  -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$GOOGLE_API_KEY" |
    tee t.gemini_out.json

cat t.gemini_out.json | jq -r .candidates[0].content.parts[0].text
