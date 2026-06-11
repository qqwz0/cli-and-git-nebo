#!/usr/bin/env bash
# fs-ops.sh - Linux filesystem operations demo.
# Chains: create -> list -> copy -> move -> symlink -> change permissions -> delete.
# Mirrors scripts/windows/fs-ops.ps1 with Linux-native commands.
# Run from the repo root:  ./scripts/linux/fs-ops.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$SCRIPT_DIR/../../build/fs-demo"

echo "== 1. Create a working directory and a file =="
mkdir -p "$WORK"
echo "hello from linux" > "$WORK/original.txt"

echo "== 2. List directory contents =="
ls -l "$WORK"

echo "== 3. Copy the file =="
cp "$WORK/original.txt" "$WORK/copy.txt"

echo "== 4. Move (rename) the copy =="
mv "$WORK/copy.txt" "$WORK/moved.txt"

echo "== 5. Create a symbolic link =="
# On Linux a symlink needs no special privileges (unlike Windows).
ln -sf "$WORK/original.txt" "$WORK/link-to-original.txt"

echo "== 6. Change permissions (read-only for everyone via chmod) =="
chmod 444 "$WORK/original.txt"
ls -l "$WORK/original.txt"

echo "== 7. Final listing, then clean up =="
ls -l "$WORK"
chmod -R u+w "$WORK"   # restore write so cleanup can remove read-only file
rm -rf "$WORK"
echo "Cleaned up $WORK"
