# kvoice

A simple voice-to-text tool for KDE (Wayland) using OpenAI's Whisper.

## Usage
1.  Run `setup.sh` to install dependencies.
2.  Add `Meta+V` (or any shortcut) to `kvoice.sh` in KDE System Settings.
3.  Press the shortcut to start recording.
4.  Press it again to stop and transcribe.
5.  The text will be copied to your clipboard and shown in a notification.

## Configuration
- **API (Recommended)**: `export OPENAI_API_KEY='...'`
- **Local**: `python3 -m pip install --user openai-whisper`
