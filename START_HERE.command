#!/bin/bash
cd "/Users/jacobcoleman/Library/Application Support/Claude/local-agent-mode-sessions/5fc72d71-fb46-4a1e-a011-3078663b7c44/2f81aef4-4e90-4b37-92eb-9891597812ed/local_05e111a5-7971-4f70-ac82-498d483a8aff/outputs/devportfolio"
echo "=== Installing dependencies (this takes ~30 seconds) ==="
npm install
echo "=== Starting dev server ==="
npm run dev
