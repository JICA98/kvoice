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
        subprocess.Popen(['wl-copy'], stdin=subprocess.PIPE).communicate(input=text.encode())
        subprocess.run(['notify-send', 'Transcription Complete', text])
        print(text)
    else:
        subprocess.run(['notify-send', 'Transcription Failed', 'No speech detected.'])

if __name__ == "__main__":
    main()
