
//////////////////////////////////////////////////////////////////////
    
	       Backup And Launch
       Author: Michal "Ali" Kawczynski
	   
//////////////////////////////////////////////////////////////////////	   






Add-Type -AssemblyName System.Windows.Forms

function Show-Notification {
    param (
        [string]$title,
        [string]$message
    )

    $notifyIcon = New-Object System.Windows.Forms.NotifyIcon
    $notifyIcon.Icon = [System.Drawing.SystemIcons]::Information
    $notifyIcon.BalloonTipTitle = $title
    $notifyIcon.BalloonTipText = $message
    $notifyIcon.Visible = $true

    $notifyIcon.ShowBalloonTip(3000)
    Start-Sleep -Seconds 5
    $notifyIcon.Visible = $false
    $notifyIcon.Dispose()
}

# Lista plików do backupu 
$sourceFiles = @(
    "G:\Falcon BMS 4.37\User\Config\XXX.ini",
    "G:\Falcon BMS 4.37\User\Config\BMS - Auto.key"
)

# Ścieżka do folderu kopii zapasowych
$backupFolder = "G:\Falcon BMS 4.37\User\Config\My_Backup\" # ŚCIEŻKA DO FOLDERU Z KOPIAMI ZAPASOWYMI.

# Maksymalna liczba kopii zapasowych
$maxBackups = 2  

# Upewnij się, że folder backupu istnieje
if (-not (Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder
}

# Funkcja do tworzenia kopii zapasowej
function Backup-File {
    param (
        [string]$sourceFile,
        [string]$backupFolder
    )

    if (Test-Path $sourceFile) {
        # Nazwa pliku i rozszerzenie
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($sourceFile)
        $fileExtension = [System.IO.Path]::GetExtension($sourceFile)

        # Generowanie nazwy kopii zapasowej z datą
        $backupFile = "$backupFolder\$fileName-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')$fileExtension"

        # Kopiowanie pliku
        Copy-Item -Path $sourceFile -Destination $backupFile -Force

        # Logowanie utworzenia kopii zapasowej
        Log-Message "Utworzono kopię zapasową pliku: $sourceFile do $backupFile"

        # Zarządzanie liczbą kopii zapasowych
        $backupFiles = Get-ChildItem -Path $backupFolder -Filter "$fileName*$fileExtension" | Sort-Object CreationTime
        if ($backupFiles.Count -gt $maxBackups) {
            $filesToRemove = $backupFiles | Select-Object -First ($backupFiles.Count - $maxBackups)
            foreach ($fileToRemove in $filesToRemove) {
                Log-Message "Usuwanie najstarszego pliku backupu: $($fileToRemove.FullName)"
                Remove-Item $fileToRemove.FullName -Force
            }
        }
    } else {
        Log-Message "Plik nie istnieje: $sourceFile"
    }
}

# Funkcja do logowania
$logFile = "G:\Falcon BMS 4.37\User\Config\My_Backup\backup_log.txt"  # ŚCIEŻKA DO FOLDERU, GDZIE MA ZOSTAĆ PLIK Z LOGAMI.
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

# Backup każdego pliku z listy
foreach ($sourceFile in $sourceFiles) {
    Log-Message "Przetwarzanie pliku: $sourceFile"
    Backup-File -sourceFile $sourceFile -backupFolder $backupFolder
}

# Powiadomienie o zakończeniu procesu backupu
Show-Notification -title "Backup Process" -message "Tworzenie kopii zapasowej pliku/plikow zostalo zakonczone."

# Logowanie uruchomienia aplikacji
Log-Message "Uruchamianie aplikacji: FalconBMS_Alternative_Launcher.exe"

# Uruchomienie aplikacji
Start-Process "G:\Falcon BMS 4.37\Launcher\FalconBMS_Alternative_Launcher.exe" # ŚCIEŻKA DO PLIKU WYKONYWALNEGO.

