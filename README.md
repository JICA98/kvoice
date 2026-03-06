# kvoice

A simple voice-to-text tool for KDE (Wayland) using OpenAI's Whisper.

## Features
- **Single Toggle**: One shortcut to start and stop recording.
- **Auto-Paste**: Automatically types the transcribed text into the active window.
- **Clipboard Fallback**: Copies to clipboard if pasting isn't possible.
- **Isolated Environment**: Uses a Python virtual environment for dependencies.

## Setup
1.  Run `./setup.sh` to install dependencies and create the virtual environment.
2.  Add a global shortcut in KDE System Settings:
    - **Command**: `/path/to/kvoice/kvoice.sh`
3.  Ensure `OPENAI_API_KEY` is set in your environment for fast cloud-based transcription (optional, defaults to local Whisper).

## Usage
1.  Press the shortcut. Notification: "Started listening".
2.  Speak.
3.  Press the shortcut again.
4.  The text is typed into your active window and a notification shows the transcribed text.
