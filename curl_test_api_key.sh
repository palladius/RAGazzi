
source .env

set -euo pipefail

echo "Tesdting Gemini with simple curl with key=$GOOGLE_API_KEY"

curl \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"parts":[{"text":"Explain how AI works"}]}]}' \
  -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$GOOGLE_API_KEY" |
    tee t.gemini_out.json

cat t.gemini_out.json | jq -r .candidates[0].content.parts[0].text
