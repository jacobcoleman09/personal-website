#!/bin/bash
# Step 1: Generate SSH key and open GitHub to add it
# After running this, paste the key on GitHub, then run STEP2_PUSH.command

echo "=== Generating SSH key for GitHub ==="
mkdir -p ~/.ssh

# Generate key if it doesn't exist
if [ ! -f ~/.ssh/github_portfolio ]; then
  ssh-keygen -t ed25519 -C "jacobcoleman09@gmail.com" -f ~/.ssh/github_portfolio -N ""
  echo "SSH key generated!"
else
  echo "Key already exists, reusing it."
fi

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_portfolio

# Configure SSH to use this key for GitHub
cat >> ~/.ssh/config << 'EOF'

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_portfolio
EOF

# Show the public key and copy to clipboard
echo ""
echo "================================================"
echo "  YOUR PUBLIC KEY (already copied to clipboard):"
echo "================================================"
cat ~/.ssh/github_portfolio.pub
cat ~/.ssh/github_portfolio.pub | pbcopy
echo ""
echo "================================================"
echo "  NOW: Add this key to GitHub:"
echo "  1. A browser tab will open to GitHub's SSH settings"
echo "  2. Click 'New SSH key'"
echo "  3. Title: 'Portfolio Deploy'"
echo "  4. Paste the key (it's already in your clipboard)"
echo "  5. Click 'Add SSH key'"
echo "  6. Then run STEP2_PUSH.command"
echo "================================================"

# Open GitHub SSH settings page
open "https://github.com/settings/ssh/new"
