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
- **Cross-Platform**: Native support for **Linux (KDE/GNOME/Hyprland)** and **Windows (PowerShell)**.

## 🚀 Quick Start

### Linux (Wayland/X11)
Includes specific support for KDE, GNOME, and Hyperland (via `wtype`).
1. Clone the repository and run the setup script:
   ```bash
   ./setup.sh
   ```
2. Assign a shortcut to `/path/to/kvoice/kvoice.sh`.

### Windows 🪟
1. Ensure `ffmpeg` is installed (e.g., `winget install ffmpeg`).
2. Run the setup script in PowerShell:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File .\setup.ps1
   ```
3. Assign a global shortcut (using tools like **AutoHotkey** or **PowerToys Run**) to:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File C:\path\to\kvoice\kvoice.ps1
   ```

## 🛠️ Platform Specifics

| Platform | Tooling Used | Notes |
| :--- | :--- | :--- |
| **KDE/GNOME** | `notify-send`, `wtype`/`xdotool`, `wl-copy`/`xclip` | Standard Linux behavior. |
| **Hyprland** | `wtype`, `wl-clipboard` | Ensure `wtype` is installed for auto-paste. |
| **Windows** | `PowerShell`, `pyautogui`, `clip` | Uses PowerShell for notifications and `pyautogui` for typing. |

### 3. (Optional) OpenAI API Key
For the best speed, set your OpenAI API key in your environment (e.g., in `.bashrc` or `.zshrc` on Linux, or System Environment Variables on Windows):
```bash
export OPENAI_API_KEY='your-key-here'
```
If not set, it will automatically fall back to the local **Whisper "base" model**.

## 🛠️ Architecture

- `kvoice.sh` / `kvoice.ps1`: Platform-specific wrappers that manage state and coordinate `ffmpeg` for recording.
- `transcribe.py`: Cross-platform Python script that handles core transcription logic and UI interaction (pasting/notifications).
- `.venv/`: Dedicated environment for all Python dependencies.

## 📝 Dependencies

- **System**: `ffmpeg`, `libnotify`, `wl-clipboard` (Wayland), `xclip` (X11), `wtype` (Wayland-paste), `xdotool` (X11-paste).
- **Python**: `openai`, `openai-whisper`, `torch`.

## ⚖️ License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
