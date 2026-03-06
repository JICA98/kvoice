# kvoice Setup Script for Windows

Write-Host "Setting up kvoice for Windows..." -ForegroundColor Cyan

# 1. Check for ffmpeg
if (!(Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "ffmpeg not found. Please install it (e.g., 'winget install ffmpeg') and restart your terminal." -ForegroundColor Yellow
} else {
    Write-Host "ffmpeg found." -ForegroundColor Green
}

# 2. Create Virtual Environment
if (!(Test-Path ".venv")) {
    Write-Host "Creating Python virtual environment..." -ForegroundColor Cyan
    python -m venv .venv
} else {
    Write-Host "Virtual environment already exists." -ForegroundColor Green
}

# 3. Install dependencies
Write-Host "Installing Python dependencies..." -ForegroundColor Cyan
& ".\.venv\Scripts\pip.exe" install openai openai-whisper torch pyautogui

# 4. Check for OpenAI API Key
if ($env:OPENAI_API_KEY) {
    Write-Host "OPENAI_API_KEY is set. Cloud transcription will be used." -ForegroundColor Green
} else {
    Write-Host "OPENAI_API_KEY not found. Local Whisper will be used." -ForegroundColor Yellow
}

Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "To use kvoice, assign a shortcut to run: powershell.exe -ExecutionPolicy Bypass -File `"$PSScriptRoot\kvoice.ps1`"" -ForegroundColor Cyan
