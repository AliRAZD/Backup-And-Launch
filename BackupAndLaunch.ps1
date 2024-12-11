

 ############################################################   
	       #Backup And Launch 
		       #Version 1.1
       #Author: Michal "Ali" Kawczynski
############################################################	   
	   






Add-Type -AssemblyName System.Windows.Forms


[System.Windows.Forms.Application]::DoEvents()


function Show-ProgressWindow {
    param (
        [int]$maxValue
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Creating a Backup"
    $form.Width = 450
    $form.Height = 200
    $form.StartPosition = "CenterScreen"

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Minimum = 0
    $progressBar.Maximum = $maxValue
    $progressBar.Step = 1
    $progressBar.Width = 400
    $progressBar.Height = 25
    $progressBar.Top = 50
    $progressBar.Left = 20

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Preparation..."
    $label.Top = 90
    $label.Left = 20
    $label.Width = 400

    $form.Controls.Add($progressBar)
    $form.Controls.Add($label)

    
    $form.Show()

    return @{
        Form = $form
        ProgressBar = $progressBar
        Label = $label
    }
}


function Update-Progress {
    param (
        [System.Windows.Forms.ProgressBar]$progressBar,
        [System.Windows.Forms.Label]$label,
        [string]$currentFile
    )

    $progressBar.PerformStep()
    $label.Text = "Copying a file: $currentFile"
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Seconds 1 
}


# List of files to backup
$sourceFiles = @(
    "G:\Falcon BMS 4.37\User\Config\Ali.ini",
    "G:\Falcon BMS 4.37\User\Config\BMS - Auto.key"
)

# Set YOUR own paths
$backupFolder = "G:\Falcon BMS 4.37\User\Config\My_Backup\"


$logFile = Join-Path -Path $backupFolder -ChildPath "backup_log.txt"

# Number of backups per file
$maxBackups = 2


if (-not (Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder
}


function Backup-File {

    param (
        [string]$sourceFile,
        [string]$backupFolder
    )

    if (Test-Path $sourceFile) {
        try {
            
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($sourceFile)
            $fileExtension = [System.IO.Path]::GetExtension($sourceFile)

            
            $backupFile = "$backupFolder\$fileName-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')$fileExtension"

            
            Copy-Item -Path $sourceFile -Destination $backupFile -Force

            
            Log-Message -level "INFO" -message "The file has been backed up: $sourceFile do $backupFile"

            
            $backupFiles = Get-ChildItem -Path $backupFolder -Filter "$fileName*$fileExtension" | Sort-Object CreationTime
            if ($backupFiles.Count -gt $maxBackups) {
                $filesToRemove = $backupFiles | Select-Object -First ($backupFiles.Count - $maxBackups)
                foreach ($fileToRemove in $filesToRemove) {
                    try {
                        Log-Message -level "INFO" -message "Deleting the oldest backup file: $($fileToRemove.FullName)"
                        Remove-Item $fileToRemove.FullName -Force
                    } catch {
                        Log-Message -level "ERROR" -message "File deletion error: $($fileToRemove.FullName). Szczegóły: $_"
                    }
                }
            }
        } catch {
            Log-Message -level "ERROR" -message "File backup error: $sourceFile. Szczegóły: $_"
        }
    } else {
        Log-Message -level "WARNING" -message "The file does not exist: $sourceFile"
    }
}


function Log-Message {
    param (
        [string]$level,
        [string]$message
    )
     $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] - $message"
    Add-Content -Path $logFile -Value "`n==== $timestamp ==== `n$logEntry"
	
	
}

$filesCopied = 0


$errorsCount = 0


$errorMessages = @()

$progress = Show-ProgressWindow -maxValue $sourceFiles.Count


foreach ($sourceFile in $sourceFiles) {
    try {
        Log-Message -level "INFO" -message "File processing: $sourceFile"
        Backup-File -sourceFile $sourceFile -backupFolder $backupFolder
        Update-Progress -progressBar $progress.ProgressBar -label $progress.Label -currentFile $sourceFile
        $filesCopied++
    } catch {
        $errorMessages += "File processing error: $sourceFile. Details: $_"
        $errorsCount++
        Log-Message -level "ERROR" -message "File processing error: $sourceFile. Details: $_"
    }
}


Start-Sleep -Seconds 2
$progress.Form.Close()


Log-Message -level "INFO" -message "Running the application: FalconBMS_Alternative_Launcher.exe"


$reportMessage = "===== Final report =====`n" +
    "Files copied: $filesCopied`n" +
    "Errors: $errorsCount`n"

if ($errorsCount -gt 0) {
    $reportMessage += "`nError details:`n"
    foreach ($error in $errorMessages) {
        $reportMessage += "$error`n"
    }
}


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show(
    $reportMessage,
    "Final report",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)


Start-Process "G:\Falcon BMS 4.37\Launcher\FalconBMS_Alternative_Launcher.exe"

