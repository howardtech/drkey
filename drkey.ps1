##############
# Dr.Key v1.0 by Gary Howard
# Prereq: PWSH 5.x or later, HPEilocmdlets module, ilo.csv file
# Purpose: To Change the Key Manager configuration on iLO5
# Updates: none 
##############

#Import and load the iLO cmdlets module
Import-Module -name HPEiLOCmdlets

Write-Host "

_____         _  __          
|  __ \       | |/ /          
| |  | |_ __  | ' / ___ _   _ 
| |  | | '__| |  < / _ \ | | |
| |__| | |_   | . \  __/ |_| |
|_____/|_(_)  |_|\_\___|\__, |
                        __/ |
                       |___/ 

                       By Gary Howard

"
#Ask User for iLO Creds
Write-Host "Please Provide iLO Credentials that will be used to access the iLO(s)"
$Creds = Get-Credential -Message "Enter iLO Username and Password"

#Ask user for CSV file and stores it in an Array
$filepath = Read-Host "Please provide the full path of the CSV file ex C:\Users"
$Hostname=@()
Import-Csv $filepath | ForEach-Object{
    $Hostname += $_.hostname
}

#Ask User for Key Manager information and stores in variables
$KeyUsername = Read-Host "Please enter Key Manager Username"
$KeyPassword = Read-Host "Please enter Key Manager Password"
$KeyGroup = Read-Host "Please enter Key Manager Group Name"
$KeyRedundacy = Read-Host "Does it Required Redundacy? Enter Yes or No"
$KeyCertName = Read-Host "Please enter Key Manager Cert Name"
$KeyPrimaryServer = Read-Host "Please enter Key Manager Primary IP address"
$KeyPrimaryPort = Read-Host "Please enter Primary Server Port"
$KeySecondaryServer = Read-Host "Please enter Key Manager Secondary IP address"
$KeySecondaryPort = Read-Host "Please enter Secondary Server Port"

#Connection String for connecting to iLO 
$connection = Connect-HPEilo -IP $Hostname -Credential $Creds 

#Connects to iLO via pipeline and and run cmdlet to configure Key Manager
Set-HPEiLOESKMSetting -Connection $connection -ESKMUsername $KeyUsername -ESKMPassword $KeyPassword -ESKMGroupName $KeyGroup -EnableRedundancy $KeyRedundacy -ESKMCertName "$KeyCertName" -ESKMPrimaryServerAddress $KeyPrimaryServer -ESKMPrimaryServerPort $KeyPrimaryPort -ESKMSecondaryServerAddress $KeySecondaryServer -ESKMSecondaryServerPort $KeySecondaryPort

#Reset iLO and wait and then Test Key Manager settings
Reset-HPEiLO -Connection $connection -Device iLO
Write-Host "Starting timer for 2 mins"
Start-Sleep -Seconds 120

#Test Key Manager Connection with applied settings
Test-HPEiLOESKMConnection -Connection $connection









