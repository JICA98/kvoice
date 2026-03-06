#!/usr/bin/env python3
import sys
import os
import subprocess
from openai import OpenAI

def transcribe(audio_file):
    api_key = os.getenv("OPENAI_API_KEY")
    if api_key:
        client = OpenAI(api_key=api_key)
        with open(audio_file, "rb") as f:
            transcript = client.audio.transcriptions.create(model="whisper-1", file=f)
        return transcript.text
    else:
        try:
            import whisper
            model = whisper.load_model("base")
            result = model.transcribe(audio_file)
            return result["text"]
        except ImportError:
            print("Error: openai-whisper not installed and OPENAI_API_KEY not set.", file=sys.stderr)
            sys.exit(1)

def main():
    if len(sys.argv) < 2:
        sys.exit(1)
    
    audio_file = sys.argv[1]
    text = transcribe(audio_file).strip()
    
    if text:
        # 1. Copy to clipboard (detect Wayland vs X11)
        is_wayland = os.environ.get("XDG_SESSION_TYPE") == "wayland"
        
        try:
            if is_wayland:
                subprocess.Popen(['wl-copy'], stdin=subprocess.PIPE).communicate(input=text.encode())
            else:
                subprocess.Popen(['xclip', '-selection', 'clipboard'], stdin=subprocess.PIPE).communicate(input=text.encode())
        except Exception as e:
            print(f"Warning: Failed to copy to clipboard: {e}", file=sys.stderr)

        # 2. Try to Paste (Type the text)
        pasted = False
        try:
            if is_wayland:
                # wtype is the standard for Wayland
                subprocess.run(['wtype', text], check=True)
                pasted = True
            else:
                # xdotool for X11
                subprocess.run(['xdotool', 'type', '--clearmodifiers', text], check=True)
                pasted = True
        except Exception as e:
            print(f"Note: Auto-paste failed (likely tool not installed or focused window incompatible): {e}", file=sys.stderr)

        # 3. Notification (Simplified)
        subprocess.run(['notify-send', 'kvoice', text])
        
        print(text)
    else:
        subprocess.run(['notify-send', 'kvoice', 'No speech detected.'])

if __name__ == "__main__":
    main()
