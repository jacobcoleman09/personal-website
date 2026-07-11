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

# Remove any stale git lock files
rm -f .git/config.lock .git/index.lock .git/HEAD.lock 2>/dev/null || true

# Configure git identity
git config user.name "Jacob Coleman"
git config user.email "jacobcoleman09@gmail.com"

# Initialize and commit
echo "=== Setting up git ==="
git init -b main 2>/dev/null || git checkout -b main 2>/dev/null || git branch -M main 2>/dev/null || true
git add -A
git commit -m "Initial portfolio deployment" 2>/dev/null || git commit -m "Update portfolio" 2>/dev/null || echo "Nothing new to commit."

# Push to GitHub
echo ""
echo "=== Pushing to GitHub ==="

# Try gh CLI first (most reliable)
if command -v gh &> /dev/null; then
  echo "Using gh CLI..."
  gh repo create "$GITHUB_USER/$REPO_NAME" --public --source=. --remote=origin --push 2>/dev/null || {
    echo "Repo exists — pushing to existing repo..."
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
    git push -u origin main --force
  }
else
  echo "gh CLI not found — using git push..."
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
