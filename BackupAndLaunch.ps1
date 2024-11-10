
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

# List of files to backup 
$sourceFiles = @(
    "G:\Falcon BMS 4.37\User\Config\XXX.ini", # EXAMPLE 
    "G:\Falcon BMS 4.37\User\Config\BMS - Auto.key"  #EXAMPLE
)

# Path to the backup folder
$backupFolder = "G:\Falcon BMS 4.37\User\Config\My_Backup\" # EXAMPLE

# Number of backups per file
$maxBackups = 2  #  EXAMPLE


if (-not (Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder
}


function Backup-File {
    param (
        [string]$sourceFile,
        [string]$backupFolder
    )

    if (Test-Path $sourceFile) {
        
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($sourceFile)
        $fileExtension = [System.IO.Path]::GetExtension($sourceFile)

        
        $backupFile = "$backupFolder\$fileName-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')$fileExtension"

        
        Copy-Item -Path $sourceFile -Destination $backupFile -Force

        
        Log-Message "Backup file created: $sourceFile do $backupFile"

        
        $backupFiles = Get-ChildItem -Path $backupFolder -Filter "$fileName*$fileExtension" | Sort-Object CreationTime
        if ($backupFiles.Count -gt $maxBackups) {
            $filesToRemove = $backupFiles | Select-Object -First ($backupFiles.Count - $maxBackups)
            foreach ($fileToRemove in $filesToRemove) {
                Log-Message "Deleting the oldest backup file: $($fileToRemove.FullName)"
                Remove-Item $fileToRemove.FullName -Force
            }
        }
    } else {
        Log-Message "The file does not exist: $sourceFile"
    }
}

# Path to LOG file
$logFile = "G:\Falcon BMS 4.37\User\Config\My_Backup\backup_log.txt"  # EXAMPLE
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}


foreach ($sourceFile in $sourceFiles) {
    Log-Message "File processing: $sourceFile"
    Backup-File -sourceFile $sourceFile -backupFolder $backupFolder
}


Show-Notification -title "Backup Process" -message "The backup of the file(s) has been completed."


Log-Message "Running the application: FalconBMS_Alternative_Launcher.exe"


Start-Process "G:\Falcon BMS 4.37\Launcher\FalconBMS_Alternative_Launcher.exe" # EXAMPLE

