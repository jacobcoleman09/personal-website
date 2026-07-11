#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
GITHUB_USER="jacobcoleman09"
REPO_NAME="personal-website"

echo "================================================"
echo "  Deploying Jacob Coleman Portfolio to GitHub"
echo "================================================"
echo ""

cd "$REPO_DIR"

# Configure git identity
git config user.name "Jacob Coleman"
git config user.email "jacobcoleman09@gmail.com"

# Initialize and commit
echo "=== Setting up git ==="
git init -b main 2>/dev/null || git checkout -b main 2>/dev/null || true
git add -A
git commit -m "Initial portfolio deployment" 2>/dev/null || echo "Already committed."

# Create GitHub repo via API (uses stored credentials / gh CLI)
echo ""
echo "=== Creating GitHub repository ==="

# Try gh CLI first (most reliable)
if command -v gh &> /dev/null; then
  gh repo create "$GITHUB_USER/$REPO_NAME" --public --source=. --remote=origin --push 2>/dev/null || {
    echo "Repo may already exist — adding remote and pushing..."
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
    git push -u origin main --force
  }
else
  echo "gh CLI not found — using git push directly..."
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
  git push -u origin main --force
fi

echo ""
echo "================================================"
echo "  DONE! Now enable GitHub Pages:"
echo ""
echo "  1. Go to: https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages"
echo "  2. Under 'Source', select 'GitHub Actions'"
echo "  3. Wait ~2 minutes for the first deploy"
echo ""
echo "  Your site will be live at:"
echo "  https://$GITHUB_USER.github.io/$REPO_NAME/"
echo "================================================"
