<p align="center">
  <img src="assets/logo.png" width="200" alt="kvoice logo">
</p>

# kvoice 🎙️

<p align="center">
  <a href="https://github.com/JICA98/kvoice/releases"><img src="https://img.shields.io/github/v/release/JICA98/kvoice?include_prereleases&style=flat-square" alt="Release"></a>
  <a href="https://github.com/JICA98/kvoice/blob/psycho/LICENSE"><img src="https://img.shields.io/github/license/JICA98/kvoice?style=flat-square" alt="License"></a>
  <a href="https://github.com/JICA98/kvoice/stargazers"><img src="https://img.shields.io/github/stars/JICA98/kvoice?style=flat-square" alt="Stars"></a>
  <a href="https://github.com/JICA98/kvoice/issues"><img src="https://img.shields.io/github/issues/JICA98/kvoice?style=flat-square" alt="Issues"></a>
  <a href="https://github.com/JICA98/kvoice/network/members"><img src="https://img.shields.io/github/forks/JICA98/kvoice?style=flat-square" alt="Forks"></a>
</p>

A lightweight, efficient voice-to-text tool designed for KDE Plasma (Wayland/X11). It features a single-toggle recording workflow, automatic transcription via OpenAI Whisper, and direct "auto-paste" into your active application.

## ✨ Features

- **Single Toggle Workflow**: Assign one shortcut to start and stop recording.
- **Auto-Paste**: Automatically types transcribed text into the focused window.
- **Intelligent Clipboard**: Always maintains a copy of the transcription in the clipboard.
- **Smart Cleanup**: Automatically removes temporary audio files and stale lockfiles.
- **Isolated Environment**: Uses a local Python virtual environment to keep your system clean.
- **Hybrid Transcription**: Supports both OpenAI's Cloud API (fastest) and local Whisper models (offline/private).

## 🚀 Quick Start

### 1. Installation
Clone the repository and run the setup script:
```bash
git clone https://github.com/JICA98/kvoice.git
cd kvoice
./setup.sh
```
The setup script will:
- Install system dependencies (`ffmpeg`, `wtype`, `xdotool`, `wl-clipboard`, etc.).
- Create a `.venv` and install Python libraries.
- Set executable permissions for all scripts.

### 2. Configure KDE Shortcut
1. Open **System Settings** -> **Shortcuts** -> **Commands**.
2. Click **+ Add New**.
3. Name it `kvoice` and set the command to:
   ```bash
   /path/to/kvoice/kvoice.sh
   ```
4. Assign a shortcut (e.g., `Meta+V`).

### 3. (Optional) OpenAI API Key
For the best speed, set your OpenAI API key in your environment (e.g., in `.bashrc` or `.zshrc`):
```bash
export OPENAI_API_KEY='your-key-here'
```
If not set, it will automatically fall back to the local **Whisper "base" model**.

## 🛠️ Architecture

- `kvoice.sh`: Bash wrapper that manages state via `kvoice.lock` and coordinates `ffmpeg` for recording.
- `transcribe.py`: Python script that handles core transcription logic and UI interaction (pasting/notifications).
- `.venv/`: Dedicated environment for all Python dependencies.

## 📝 Dependencies

- **System**: `ffmpeg`, `libnotify`, `wl-clipboard` (Wayland), `xclip` (X11), `wtype` (Wayland-paste), `xdotool` (X11-paste).
- **Python**: `openai`, `openai-whisper`, `torch`.

## ⚖️ License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
