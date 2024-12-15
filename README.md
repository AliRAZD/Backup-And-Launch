# Backup and Launch Script For Falcon BMS.
---
### This script creates a backup of the file or files every time when you launch the game.



## HOW TO :

> [!IMPORTANT]
> COPY AND PASTE BackupAndLaunch.ps1 TO X:\Falcon BMS 4.37\User\Config\ 

### 1. Modify the Falcon BMS shortcut. Replace the original path with the one shown below.
> [!IMPORTANT]
> C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process; & 'XXX:\Falcon BMS 4.37\User\Config\BackupAndLaunch.ps1'"
> ![image](https://github.com/user-attachments/assets/621320fc-93bd-439e-9727-4284bfb8d5b4)

In shortcut, set your own path to the script "XXX:\Falcon BMS 4.37\User\Config\BackupAndLaunch.ps1".
   
   > [!WARNING]
> Falcon BMS icon will change.
> 

   ![image](https://github.com/user-attachments/assets/8b93f276-e4c6-4400-abe7-c68524e049e5)


### 2. Launch BMS from the desktop shortcut.

   #Choose folder for backup files.
   
   ![image](https://github.com/user-attachments/assets/8c396e1f-76cc-43a2-b7c8-65bb8a29d3cc)



   #Choose, which file will be copying to the backup folder.

   ![image](https://github.com/user-attachments/assets/1f0f4697-32a7-4dab-917a-ea7e6c371fd5)

   #You can add more files from diffrent location or delete unwanted. If you finish, click OK.
   
   ![image](https://github.com/user-attachments/assets/ac754d69-7f57-4289-997d-3d732055ade4)

   #Last step. Choose FalconBMS_Alternative_Launcher.exe from  ...\Falcon BMS 4.37\Launcher

   ![image](https://github.com/user-attachments/assets/fba3e718-634a-4df8-9407-8796ea15c547)



   #  Thats all
   #  Now, every time when you run Falcon BMS, the script will create a backup file.

   


   




   


   


   


