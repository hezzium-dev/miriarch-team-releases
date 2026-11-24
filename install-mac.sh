#!/bin/bash
# Installs (or reinstalls) the newest Miriarch team build on an Apple Silicon Mac:
#
#   curl -fsSL https://raw.githubusercontent.com/hezzium-dev/miriarch-team-releases/main/install-mac.sh | bash
#
# Team builds are signed with Miriarch's own certificate, not Apple's, so a copy downloaded in a
# browser is stopped by Gatekeeper. curl doesn't mark what it downloads as quarantined, so the
# app installed here opens directly. After that it updates itself (the tray's "Restart to
# update"). Source: ops/release/team/install-mac.sh in Miriarch's repository; the team workflow
# (.github/workflows/team-desktop.yml) doesn't change it, so copy it over by hand when it does.
set -euo pipefail

REPO="hezzium-dev/miriarch-team-releases"
APP="/Applications/Miriarch.app"

if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
  echo "Team builds are for Apple Silicon Macs (and Windows). This is $(uname -s) $(uname -m)." >&2
  exit 1
fi

echo "Finding the newest team build…"
url=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" |
  grep -o '"browser_download_url": *"[^"]*-arm64-mac\.zip"' |
  sed -E 's/.*"(https:[^"]+)"$/\1/' | head -n 1)
if [ -z "$url" ]; then
  echo "No macOS build in the newest release of $REPO." >&2
  exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
echo "Downloading $(basename "$url")…"
curl -fL --progress-bar "$url" -o "$tmp/miriarch.zip"
ditto -x -k "$tmp/miriarch.zip" "$tmp/unpacked"
if [ ! -d "$tmp/unpacked/Miriarch.app" ]; then
  echo "The download has no Miriarch.app." >&2
  exit 1
fi

if pgrep -xq Miriarch; then
  echo "Quitting Miriarch…"
  osascript -e 'quit app "Miriarch"' >/dev/null 2>&1 || true
  for _ in $(seq 1 30); do pgrep -xq Miriarch || break; sleep 1; done
  if pgrep -xq Miriarch; then
    echo "Miriarch is still running (agents mid-turn?). Quit it from the tray, then run this again." >&2
    exit 1
  fi
fi

echo "Installing into /Applications…"
rm -rf "$APP"
ditto "$tmp/unpacked/Miriarch.app" "$APP"
xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true

echo "Installed. Opening Miriarch…"
open "$APP"
