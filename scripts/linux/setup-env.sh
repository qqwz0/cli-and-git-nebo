#!/usr/bin/env bash
# setup-env.sh - Linux environment setup for the todo app.
# Chains several routine operations: check tools -> install deps -> prepare folders.
# Run from the repo root:  ./scripts/linux/setup-env.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "== 1. Checking required tools =="
node --version
npm --version

echo
echo "== 2. Installing project dependencies =="
cd "$ROOT_DIR"
npm install

echo
echo "== 3. Preparing runtime folders =="
BUILD_DIR="$ROOT_DIR/build"
if [ ! -d "$BUILD_DIR" ]; then
  mkdir -p "$BUILD_DIR"
  echo "Created $BUILD_DIR"
else
  echo "$BUILD_DIR already exists"
fi

echo
echo "== 4. Environment ready. Start the app with: npm start =="
