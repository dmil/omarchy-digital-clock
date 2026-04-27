#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EWW_CONFIG_DIR="$HOME/.config/eww"

echo "==> Installing Omarchy Digital Clock widget"
echo

# ── 1. Check eww ─────────────────────────────────────────────────────────────
if ! command -v eww &>/dev/null; then
  echo "--> Installing eww from AUR..."
  yay -S --noconfirm eww
else
  echo "--> eww already installed: $(eww --version)"
fi

# ── 2. Merge eww config ───────────────────────────────────────────────────────
echo "--> Merging clock config into $EWW_CONFIG_DIR ..."
mkdir -p "$EWW_CONFIG_DIR"

# Backup existing files
if [ -f "$EWW_CONFIG_DIR/eww.yuck" ]; then
  cp "$EWW_CONFIG_DIR/eww.yuck" "$EWW_CONFIG_DIR/eww.yuck.bak.$(date +%s)"
  echo "  Backed up existing eww.yuck"
fi
if [ -f "$EWW_CONFIG_DIR/eww.scss" ]; then
  cp "$EWW_CONFIG_DIR/eww.scss" "$EWW_CONFIG_DIR/eww.scss.bak.$(date +%s)"
  echo "  Backed up existing eww.scss"
fi

# Append clock definitions (idempotent — skip if already present)
if grep -q "defwindow clock" "$EWW_CONFIG_DIR/eww.yuck" 2>/dev/null; then
  echo "  Clock widget already in eww.yuck — skipping"
else
  echo "" >> "$EWW_CONFIG_DIR/eww.yuck"
  cat "$SCRIPT_DIR/eww/clock.yuck" >> "$EWW_CONFIG_DIR/eww.yuck"
  echo "  Appended clock.yuck"
fi

if grep -q "clock-root" "$EWW_CONFIG_DIR/eww.scss" 2>/dev/null; then
  echo "  Clock styles already in eww.scss — skipping"
else
  echo "" >> "$EWW_CONFIG_DIR/eww.scss"
  cat "$SCRIPT_DIR/eww/clock.scss" >> "$EWW_CONFIG_DIR/eww.scss"
  echo "  Appended clock.scss"
fi

# ── 3. Add to Hyprland autostart (optional) ───────────────────────────────────
echo
read -rp "Add clock to Hyprland autostart? [y/N] " yn
if [[ "${yn,,}" == "y" ]]; then
  AUTOSTART="$HOME/.config/hypr/autostart.conf"
  if grep -q "eww open clock" "$AUTOSTART" 2>/dev/null; then
    echo "--> Already in autostart"
  elif grep -q "eww daemon" "$AUTOSTART" 2>/dev/null; then
    # eww daemon already started by another widget — just add open clock
    sed -i 's/eww daemon;/eww daemon; eww open clock;/' "$AUTOSTART" 2>/dev/null \
      || echo "exec-once = eww open clock" >> "$AUTOSTART"
    echo "--> Added eww open clock to autostart"
  else
    echo "" >> "$AUTOSTART"
    echo "# Digital Clock widget" >> "$AUTOSTART"
    echo "exec-once = eww daemon; eww open clock" >> "$AUTOSTART"
    echo "--> Added to $AUTOSTART"
  fi
fi

# ── 4. Launch ─────────────────────────────────────────────────────────────────
echo
read -rp "Launch the clock widget now? [Y/n] " yn
if [[ "${yn,,}" != "n" ]]; then
  eww daemon 2>/dev/null || true
  eww reload 2>/dev/null || true
  eww open clock
  echo "--> Clock widget launched!"
fi

echo
echo "==> Done!"
echo
echo "    To open:   eww open clock"
echo "    To close:  eww close clock"
echo "    To reload: eww reload"
