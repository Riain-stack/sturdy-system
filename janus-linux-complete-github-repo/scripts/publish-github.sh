#!/usr/bin/env bash
# publish-github.sh — Automate Janus Linux GitHub setup

set -e

# 1. Navigate to the project directory (ensure you're at the root of janus-linux)
#    Uncomment and adjust if needed:
# cd /path/to/janus-linux

# 2. Create GitHub repo and push
# Requires: GitHub CLI (`gh`) authenticated (run `gh auth login` first)
gh repo create YOURUSERNAME/janus-linux \
  --public \
  --source . \
  --remote origin \
  --push

# 3. Set default branch to main
git branch -M main

# 4. Push tags (if any) and all commits
git push -u origin main --follow-tags

# 5. Enable GitHub Pages on the `main` branch, /website folder
gh api \
  --method POST \
  -H "Accept: application/vnd.github.v3+json" \
  /repos/YOURUSERNAME/janus-linux/pages \
  -f source.branch=main \
  -f source.path="/website"

echo
echo "✅ Repository published at: https://github.com/YOURUSERNAME/janus-linux"
echo "✅ GitHub Pages enabled at: https://YOURUSERNAME.github.io/janus-linux/"
