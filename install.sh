#!/bin/bash
# install.sh — standalone installer for OmaCleaner
# Installs: binary -> ~/.local/bin/omacleaner
#           icon   -> ~/.local/share/icons/hicolor/256x256/apps/omacleaner.png
#           launcher -> ~/.local/share/applications/omacleaner.desktop
#
# Usage: ./install.sh  (run from the repo root after git clone / git pull)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_BIN="$REPO_DIR/omacleaner"
SRC_ICON="$REPO_DIR/assets/omacleaner.png"

BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"

DEST_BIN="$BIN_DIR/omacleaner"
DEST_ICON="$ICON_DIR/omacleaner.png"
DEST_DESKTOP="$DESKTOP_DIR/omacleaner.desktop"

if [[ ! -f "$SRC_BIN" ]]; then
  echo "ERROR: $SRC_BIN not found. Run this from the repo root." >&2
  exit 1
fi

echo "Installing OmaCleaner..."

mkdir -p "$BIN_DIR"
install -m755 "$SRC_BIN" "$DEST_BIN"
echo "  binary:   $DEST_BIN"

if [[ -f "$SRC_ICON" ]]; then
  mkdir -p "$ICON_DIR"
  install -m644 "$SRC_ICON" "$DEST_ICON"
  echo "  icon:     $DEST_ICON"
else
  echo "  WARNING: $SRC_ICON not found — skipping icon (launcher will use fallback)" >&2
fi

mkdir -p "$DESKTOP_DIR"
cat > "$DEST_DESKTOP" <<'EOF'
[Desktop Entry]
Type=Application
Name=OmaCleaner
Comment=Selectively remove preinstalled Omarchy apps
Exec=omacleaner
Icon=omacleaner
Terminal=true
Categories=System;Utility;
Keywords=omarchy;clean;remove;uninstall;
Actions=uninstall;

[Desktop Action uninstall]
Name=Uninstall OmaCleaner
Exec=omacleaner --uninstall
Icon=omacleaner
EOF
chmod +x "$DEST_DESKTOP"
echo "  launcher: $DEST_DESKTOP"

# Refresh caches (best-effort)
update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
gtk-update-icon-cache "$HOME/.local/share/icons/hicolor" 2>/dev/null || true

echo ""
echo "Done. Run 'omacleaner' or find OmaCleaner in your app launcher (SUPER+SPACE)."
echo "To uninstall: omacleaner --uninstall  (or right-click the launcher entry)"
