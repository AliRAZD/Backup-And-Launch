# Backup and Launch Script For Falcon BMS 4.37
---
The script creates a backup copy of the file or files every time when you start the game.



## HOW TO :

> <ins>COPY AND PASTE FILE BackupAndLaunch.ps1 TO X:\Falcon BMS 4.37\User\Config\ </ins>

### 1. Modify the Falcon BMS shortcut. Replace the original path with the one shown below.
> [!WARNING] 
> Set your own path "X:\Falcon BMS 4.37\User\Config\BackupAndLaunch.ps1".
   
   C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "X:\Falcon BMS 4.37\User\Config\BackupAndLaunch.ps1"

   > [!WARNING]
> Then the Falcon BMS icon will change.
> 

   ![image](https://github.com/user-attachments/assets/d93c4f70-989f-4c23-853b-f9a051b0f285)

### 2. Open and Edit BackupAndLaunch.ps1 file ( Open in txt editor like NotePad++ )

   #Set the path to the file you want to back up.

   ![image](https://github.com/user-attachments/assets/7b5da34b-b2d4-41de-9a05-45c53aa77227)
   
   #Set the path to the backup folder.

   ![image](https://github.com/user-attachments/assets/68ac7f80-6de6-484a-8fd7-ea428ddcc2ae)

   #Set the number of backups per file (per path)

   ![image](https://github.com/user-attachments/assets/aa96ed37-98b5-4ff4-be31-8b93fcd93c9d)

   #Set the path to the LOG file

   ![image](https://github.com/user-attachments/assets/651ea543-f374-4287-9394-49b016ab585a)

   #Set the path to the FalconBMS_Alternative_Launcher.exe (example : "G:\Falcon BMS 4.37\Launcher\FalconBMS_Alternative_Launcher.exe")

   ![image](https://github.com/user-attachments/assets/86c9ed15-f98a-4319-95ac-0d464106f31a)


   #  Now, every time when you run Falcon BMS, the script will create a backup file.




   


   


   


