# kvoice Toggle Script for Windows

$ScriptDir = $PSScriptRoot
$LockFile = Join-Path $ScriptDir "kvoice.lock"
$AudioFile = Join-Path $ScriptDir "kvoice.wav"
$PythonVenv = Join-Path $ScriptDir ".venv\Scripts\python.exe"
$TranscribeScript = Join-Path $ScriptDir "transcribe.py"

# Toggle Logic
if (Test-Path $LockFile) {
    $PidToKill = Get-Content $LockFile
    $Process = Get-Process -Id $PidToKill -ErrorAction SilentlyContinue
    
    if ($Process) {
        # RECORDING IS RUNNING -> STOP IT
        Stop-Process -Id $PidToKill -Force
        Remove-Item $LockFile -Force
        
        Write-Host "Recording stopped. Transcribing..." -ForegroundColor Cyan
        
        if (Test-Path $PythonVenv) {
            & $PythonVenv $TranscribeScript $AudioFile
        } else {
            python $TranscribeScript $AudioFile
        }
    } else {
        # LOCKFILE IS STALE -> CLEANUP AND START NEW
        Write-Host "Removing stale lockfile/audio." -ForegroundColor Yellow
        Remove-Item $LockFile, $AudioFile -ErrorAction SilentlyContinue
        
        Write-Host "Started listening..." -ForegroundColor Green
        $FfmpegProcess = Start-Process ffmpeg -ArgumentList "-y -f dshow -i default -t 300 `"$AudioFile`"" -WindowStyle Hidden -PassThru
        $FfmpegProcess.Id | Out-File $LockFile
    }
} else {
    # NO LOCKFILE -> START RECORDING
    Remove-Item $AudioFile -ErrorAction SilentlyContinue
    Write-Host "Started listening..." -ForegroundColor Green
    
    # Note: On Windows, -f dshow is common for audio input. 
    # 'default' might not work, usually users need to specify device name.
    # But for a generic script, we try to be as generic as possible.
    $FfmpegProcess = Start-Process ffmpeg -ArgumentList "-y -f dshow -i audio=`"default`" -t 300 `"$AudioFile`"" -WindowStyle Hidden -PassThru
    $FfmpegProcess.Id | Out-File $LockFile
}
