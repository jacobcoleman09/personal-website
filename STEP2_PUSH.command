#!/bin/bash
# Step 2: Push to GitHub via SSH (run AFTER adding key on github.com/settings/ssh/new)

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
GITHUB_USER="jacobcoleman09"
REPO_NAME="personal-website"

echo "=== Pushing portfolio to GitHub via SSH ==="
cd "$REPO_DIR"

# Load SSH key into agent
eval "$(ssh-agent -s)" 2>/dev/null
ssh-add ~/.ssh/github_portfolio 2>/dev/null

# Test SSH connection first
echo "Testing GitHub SSH connection..."
ssh -T git@github.com 2>&1 | grep -E "Hi|successfully|denied" || true

# Set SSH remote
git remote remove origin 2>/dev/null || true
git remote add origin "git@github.com:$GITHUB_USER/$REPO_NAME.git"

# Create repo on GitHub if it doesn't exist (via SSH API workaround: just push, GitHub auto-creates for user)
# Actually we need to create via web or API first. Let's try push and see.
echo ""
echo "=== Pushing to git@github.com:$GITHUB_USER/$REPO_NAME.git ==="
git push -u origin main --force

if [ $? -eq 0 ]; then
  echo ""
  echo "================================================"
  echo "  SUCCESS! Code pushed to GitHub."
  echo ""
  echo "  LAST STEP - Enable GitHub Pages:"
  echo "  Opening settings page..."
  open "https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages"
  echo ""
  echo "  Select 'GitHub Actions' as the Source."
  echo "  Wait ~2 min, then visit:"
  echo "  https://$GITHUB_USER.github.io/$REPO_NAME/"
  echo "================================================"
else
  echo ""
  echo "Push failed. The repo may not exist yet."
  echo "Opening GitHub to create it..."
  open "https://github.com/new"
  echo ""
  echo "Create a repo named: $REPO_NAME (public, no README)"
  echo "Then run this script again."
fi
