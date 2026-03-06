#!/usr/bin/env bash
# Setup Script for kvoice
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

echo "Setting up kvoice dependencies..."

# Install system dependencies
if command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y ffmpeg libnotify-bin wl-clipboard python3-pip python3-venv
elif command -v dnf &> /dev/null; then
    sudo dnf install -y ffmpeg libnotify wl-clipboard python3-pip python3-venv
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm ffmpeg libnotify wl-clipboard python-pip
fi

# Create virtual environment
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
fi

# Install python dependencies in venv
echo "Installing dependencies in virtual environment..."
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install openai openai-whisper

# Handle script renaming/creation
if [ -f "$SCRIPT_DIR/kvoice.sh" ]; then
    echo "Renaming kvoice.sh to kvoice..."
    mv "$SCRIPT_DIR/kvoice.sh" "$SCRIPT_DIR/kvoice"
fi

chmod +x "$SCRIPT_DIR/kvoice"

echo "Setup complete!"
echo "KDE Shortcut Command: $SCRIPT_DIR/kvoice"
