#!/bin/bash
if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "❌ Set your OpenAI key: export OPENAI_API_KEY=sk-..."
  exit 1
fi
read -rp "💬 Ask ChatGPT: " prompt
response=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": "'"$prompt"'"}]}')
echo "$response" | jq -r '.choices[0].message.content'
