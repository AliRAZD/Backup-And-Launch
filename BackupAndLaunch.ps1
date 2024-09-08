
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

    # Tworzenie nowego obiektu NotifyIcon za każdym razem
    $notifyIcon = New-Object System.Windows.Forms.NotifyIcon
    $notifyIcon.Icon = [System.Drawing.SystemIcons]::Information
    $notifyIcon.BalloonTipTitle = $title
    $notifyIcon.BalloonTipText = $message
    $notifyIcon.Visible = $true

    # Wyświetlenie powiadomienia
    $notifyIcon.ShowBalloonTip(3000)

    # Czekanie na zakończenie wyświetlania powiadomienia
    Start-Sleep -Seconds 5

    # Ukrycie i usunięcie ikony z tray'a po wyświetleniu powiadomienia
    $notifyIcon.Visible = $false
    $notifyIcon.Dispose()
}

# Ścieżka do pliku, którego kopię zapasową chcesz utworzyć
$sourceFile = "G:\Falcon BMS 4.37\User\Config\Ali.ini"

# Ścieżka do folderu, gdzie chcesz zapisać kopię zapasową
$backupFolder = "G:\Falcon BMS 4.37\User\Config\Backup\"

# Maksymalna liczba kopii zapasowych
$maxBackups = 2

# Sprawdź, czy folder kopii zapasowych istnieje, jeśli nie - utwórz go
if (-not (Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder
}

# Nazwa kopii zapasowej z timestampem
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = Join-Path $backupFolder ("DTC_backup_" + $timestamp + ".ini")

# Tworzenie kopii zapasowej
Copy-Item -Path $sourceFile -Destination $backupFile

# Pobierz wszystkie pliki backupu w folderze, posortowane według nazw plików
$backupFiles = Get-ChildItem -Path $backupFolder -Filter "DTC_backup_*.ini" | Sort-Object Name

# Sprawdź, czy liczba kopii zapasowych przekracza maksymalną dozwoloną ilość
if ($backupFiles.Count -gt $maxBackups) {
    # Oblicz liczbę plików do usunięcia
    $filesToRemove = $backupFiles.Count - $maxBackups
    
    # Usuń najstarsze pliki
    $backupFiles[0..($filesToRemove-1)] | ForEach-Object { Remove-Item $_.FullName -Force }
}

# Ścieżka do pliku logu
$logFile = "G:\Falcon BMS 4.37\User\Config\Backup\backup_log.txt"

# Funkcja do logowania
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

# Logowanie utworzenia kopii zapasowej
Log-Message "Tworzenie kopii zapasowej pliku: $backupFile"

# Logowanie usunięcia kopii zapasowej
if ($backupFiles.Count -gt $maxBackups) {
    $backupFiles[0..($filesToRemove-1)] | ForEach-Object {
        Log-Message "Usuwanie najstarszego pliku backupu: $($_.FullName)"
        Remove-Item $_.FullName -Force
    }
}

# Powiadomienie o zakończeniu procesu backupu
Show-Notification -title "Backup Process" -message "Tworzenie kopii zapasowej zostalo zakonczone."

# Logowanie uruchomienia aplikacji
Log-Message "Uruchamianie aplikacji: FalconBMS_Alternative_Launcher.exe"


# Uruchomienie aplikacji
Start-Process "G:\Falcon BMS 4.37\Launcher\FalconBMS_Alternative_Launcher.exe"
