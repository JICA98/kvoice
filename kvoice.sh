#!/usr/bin/env bash
# Voice-to-Text Toggle Script for KDE (Wayland)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCKFILE="$SCRIPT_DIR/kvoice.lock"
AUDIO_FILE="$SCRIPT_DIR/kvoice.wav"
PYTHON_VENV="$SCRIPT_DIR/.venv/bin/python3"

# Toggle Logic
if [ -f "$LOCKFILE" ]; then
    PID=$(cat "$LOCKFILE")
    
    # Check if PID is valid and process is running
    if [ -n "$PID" ] && ps -p "$PID" > /dev/null 2>&1; then
        # RECORDING IS RUNNING -> STOP IT
        kill $PID
        rm -f "$LOCKFILE"
        
        if [ -f "$PYTHON_VENV" ]; then
            "$PYTHON_VENV" "$SCRIPT_DIR/transcribe.py" "$AUDIO_FILE"
        else
            python3 "$SCRIPT_DIR/transcribe.py" "$AUDIO_FILE"
        fi
    else
        # LOCKFILE IS STALE -> CLEANUP AND START NEW
        echo "Removing stale lockfile/audio."
        rm -f "$LOCKFILE" "$AUDIO_FILE"
        
        rm -f "$AUDIO_FILE"
        notify-send "kvoice" "Started listening"
        ffmpeg -y -f pulse -i default -t 300 "$AUDIO_FILE" > "$SCRIPT_DIR/ffmpeg.log" 2>&1 &
        echo $! > "$LOCKFILE"
    fi
else
    # NO LOCKFILE -> START RECORDING
    rm -f "$AUDIO_FILE"
    notify-send "kvoice" "Started listening"
    ffmpeg -y -f pulse -i default -t 300 "$AUDIO_FILE" > "$SCRIPT_DIR/ffmpeg.log" 2>&1 &
    echo $! > "$LOCKFILE"
fi
