#!/usr/bin/env python3
import sys
import os
import subprocess
import platform
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

def copy_to_clipboard(text):
    system = platform.system()
    try:
        if system == "Linux":
            is_wayland = os.environ.get("XDG_SESSION_TYPE") == "wayland"
            if is_wayland:
                subprocess.Popen(['wl-copy'], stdin=subprocess.PIPE).communicate(input=text.encode())
            else:
                subprocess.Popen(['xclip', '-selection', 'clipboard'], stdin=subprocess.PIPE).communicate(input=text.encode())
        elif system == "Windows":
            # Native Windows 'clip' command
            subprocess.Popen(['clip'], stdin=subprocess.PIPE).communicate(input=text.encode())
    except Exception as e:
        print(f"Warning: Failed to copy to clipboard: {e}", file=sys.stderr)

def paste_text(text):
    system = platform.system()
    try:
        if system == "Linux":
            is_wayland = os.environ.get("XDG_SESSION_TYPE") == "wayland"
            if is_wayland:
                subprocess.run(['wtype', text], check=True)
            else:
                subprocess.run(['xdotool', 'type', '--clearmodifiers', text], check=True)
        elif system == "Windows":
            # For Windows, we'll try using pyautogui if available
            try:
                import pyautogui
                pyautogui.typewrite(text)
            except ImportError:
                # Fallback: using PowerShell to send keys (less robust for special chars but no deps)
                # Escaping single quotes for PowerShell
                escaped_text = text.replace("'", "''")
                powershell_cmd = f"$wshell = New-Object -ComObject WScript.Shell; $wshell.SendKeys('{escaped_text}')"
                subprocess.run(["powershell", "-Command", powershell_cmd], check=True)
    except Exception as e:
        print(f"Note: Auto-paste failed: {e}", file=sys.stderr)

def notify(title, message):
    system = platform.system()
    try:
        if system == "Linux":
            subprocess.run(['notify-send', title, message])
        elif system == "Windows":
            # PowerShell notification (BurntToast alternative without module)
            escaped_title = title.replace("'", "''")
            escaped_message = message.replace("'", "''")
            ps_script = f"""
            $title = '{escaped_title}'
            $msg = '{escaped_message}'
            Add-Type -AssemblyName System.Windows.Forms
            $global:balloon = New-Object System.Windows.Forms.NotifyIcon
            $path = (Get-Process -id $pid).Path
            $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
            $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::None
            $balloon.BalloonTipText = $msg
            $balloon.BalloonTipTitle = $title
            $balloon.Visible = $true
            $balloon.ShowBalloonTip(5000)
            """
            subprocess.run(["powershell", "-Command", ps_script], check=True)
    except Exception as e:
        print(f"Warning: Notification failed: {e}", file=sys.stderr)

def main():
    if len(sys.argv) < 2:
        sys.exit(1)
    
    audio_file = sys.argv[1]
    text = transcribe(audio_file).strip()
    
    if text:
        copy_to_clipboard(text)
        paste_text(text)
        notify('kvoice', text)
        print(text)
    else:
        notify('kvoice', 'No speech detected.')

if __name__ == "__main__":
    main()
