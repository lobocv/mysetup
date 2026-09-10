#!/usr/bin/env bash
#
# Bootstrap a fresh macOS machine from this repo.
#
# Run this once from any checkout location:
#     ./bootstrap.sh
#
# It installs Homebrew, reinstalls every app in the Brewfile, then symlinks
# all the tracked config files into place with stow. Secrets are NOT handled
# here; see RESTORE.md for the manual credential steps (Infisical, gh, ssh).

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Bootstrapping from $REPO_DIR"

# 1. Homebrew: the macOS package manager. Installs apps + CLIs.
if ! command -v brew >/dev/null 2>&1; then
	echo "==> Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Reinstall every app, cask, CLI and extension listed in the Brewfile.
echo "==> Installing everything in the Brewfile (this takes a while)"
brew bundle --file="$REPO_DIR/Brewfile"

# 3. Symlink all config files into $HOME with stow.
#    Each folder under stow/ is a "package" whose contents mirror $HOME.
echo "==> Symlinking dotfiles with stow"
python3 "$REPO_DIR/apply.py"

echo ""
echo "==> Done. Next steps (see RESTORE.md):"
echo "    - infisical login   (to load secrets into your shell)"
echo "    - gh auth login"
echo "    - restore SSH keys, log in to Claude / Codex"
