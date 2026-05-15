#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.nvm/versions/node/v24.11.1/bin:$PATH"
npx wrangler pages deploy . --project-name=polpo-link --branch=main --commit-dirty=true
