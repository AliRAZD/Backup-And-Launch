# Backup and Launch Script For Falcon BMS 4.37
---
This script creates a backup of the file or files every time you launch the game.



## HOW TO :

> [!IMPORTANT]
> COPY AND PASTE BackupAndLaunch.ps1 TO X:\Falcon BMS 4.37\User\Config\ 

### 1. Modify the Falcon BMS shortcut. Replace the original path with the one shown below.
> [!IMPORTANT]
> C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "& 'G:\Falcon BMS 4.37\User\Config\BackupAndLaunch.ps1'"
> 
Set your own path "X:\Falcon BMS 4.37\User\Config\BackupAndLaunch.ps1".
   
   > [!WARNING]
> Falcon BMS icon will change.
> 

   ![image](https://github.com/user-attachments/assets/8b93f276-e4c6-4400-abe7-c68524e049e5)


### 2. Open and Edit BackupAndLaunch.ps1 file ( Open in txt editor like NotePad++ )

   #Set the path to the folder where you want to save backups.

   ![image](https://github.com/user-attachments/assets/b8afd024-605e-4538-95bf-8012e675654e)


   #Set the number of backups per file (per path)

   ![image](https://github.com/user-attachments/assets/aa96ed37-98b5-4ff4-be31-8b93fcd93c9d)


   #Set the path to the FalconBMS_Alternative_Launcher.exe (example : "G:\Falcon BMS 4.37\Launcher\FalconBMS_Alternative_Launcher.exe")

   ![image](https://github.com/user-attachments/assets/86c9ed15-f98a-4319-95ac-0d464106f31a)


   #  Now, every time when you run Falcon BMS, the script will create a backup file.




   


   


   


