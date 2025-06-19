#!/bin/bash
# aicmd.sh - AI-powered shell assistant for Janus Linux
# Supports both Ollama (local) and OpenAI (cloud)

# === Configuration ===
USE_OLLAMA=true                 # Set to false to use OpenAI
OLLAMA_MODEL="llama3"
OPENAI_API_KEY="sk-REPLACE-ME"
OPENAI_MODEL="gpt-4"

# === Input Capture ===
QUERY="$*"
if [ -z "$QUERY" ]; then
  echo "Usage: aicmd <your prompt>"
  exit 1
fi

# === Ollama Mode ===
if [ "$USE_OLLAMA" = true ]; then
  if ! command -v ollama &> /dev/null; then
    echo "[ERROR] Ollama not found. Please install ollama."
    exit 1
  fi
  ollama run "$OLLAMA_MODEL" --prompt "$QUERY"

# === OpenAI Mode ===
else
  if [ -z "$OPENAI_API_KEY" ] || [[ "$OPENAI_API_KEY" == "sk-REPLACE-ME" ]]; then
    echo "[ERROR] OpenAI API key not set. Please edit aicmd.sh"
    exit 1
  fi
  RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d '{
      "model": "'$OPENAI_MODEL'",
      "messages": [{"role": "user", "content": "'$QUERY'"}],
      "temperature": 0.7
    }')

  echo "$RESPONSE" | jq -r '.choices[0].message.content'
fi
