#!/bin/bash

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
GITHUB_USER="jacobcoleman09"
REPO_NAME="personal-website"

echo "================================================"
echo "  Deploying Jacob Coleman Portfolio to GitHub"
echo "================================================"
echo ""

cd "$REPO_DIR"

# Remove stale lock files
rm -f .git/config.lock .git/index.lock .git/HEAD.lock 2>/dev/null

# Init repo if needed
if [ ! -d ".git" ]; then
  git init
fi

# Configure git identity
git config user.name "Jacob Coleman"
git config user.email "jacobcoleman09@gmail.com"

# Stage and commit everything
echo "=== Staging files ==="
git add -A

echo "=== Committing ==="
git commit -m "Deploy Jacob Coleman portfolio" 2>/dev/null || echo "Already up to date, continuing..."

# Rename branch to main (works whether we're on master or another branch)
echo "=== Setting branch to main ==="
git branch -M main 2>/dev/null || true
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
echo "Current branch: $BRANCH"

# Verify commits exist
COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
echo "Total commits: $COMMIT_COUNT"

if [ "$COMMIT_COUNT" -eq "0" ]; then
  echo "ERROR: No commits. Something went wrong."
  exit 1
fi

# Set up remote
echo ""
echo "=== Setting up remote ==="
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Push (using stored Mac git credentials)
echo "=== Pushing to GitHub ==="
git push -u origin main --force

if [ $? -eq 0 ]; then
  echo ""
  echo "================================================"
  echo "  SUCCESS! Code is on GitHub."
  echo ""
  echo "  Next: enable GitHub Pages:"
  echo "  1. Open: https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages"
  echo "  2. Under 'Source', select 'GitHub Actions'"
  echo "  3. Wait ~2 min"
  echo ""
  echo "  Live URL: https://$GITHUB_USER.github.io/$REPO_NAME/"
  echo "================================================"
else
  echo ""
  echo "Push failed — you may need to authenticate."
  echo "Run: git -C \"$REPO_DIR\" push -u origin main --force"
fi
