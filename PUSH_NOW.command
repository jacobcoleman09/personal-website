#!/bin/bash

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
KEY="$HOME/.ssh/github_portfolio"

echo "=== Pushing to GitHub ==="
cd "$REPO_DIR"

# Remove ALL lock files
rm -f .git/config.lock .git/index.lock .git/HEAD.lock 2>/dev/null

# Use GIT_SSH_COMMAND to explicitly point at the key (no agent needed)
export GIT_SSH_COMMAND="ssh -i $KEY -o StrictHostKeyChecking=accept-new -o BatchMode=yes"

# Stage and commit any pending changes
git add -A
git commit -m "Update site" 2>/dev/null || true

# Make sure we're on main
git branch -M main 2>/dev/null || true

# Set remote
git remote remove origin 2>/dev/null || true
git remote add origin "git@github.com:jacobcoleman09/personal-website.git"

# Push
echo "Pushing..."
git push -u origin main --force

if [ $? -eq 0 ]; then
  echo ""
  echo "SUCCESS! Visit:"
  echo "https://jacobcoleman09.github.io/personal-website/"
else
  echo ""
  echo "Push failed. Check output above."
fi
