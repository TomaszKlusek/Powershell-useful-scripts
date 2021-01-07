<#
.SYNOPSIS
Removing users from Active Directory

.DESCRIPTION
The script removes users from the domain environment

.PARAMETER ADusers
With this parameter, we specify the users we want to remove from the Active Directory

.PARAMETER Log
Optional parameter to create the log

.EXAMPLE
.\ActiveDirectory_Remove_users.ps1 -ADusers user1,user2 -log
#>


#Name of users
Param ($ADusers = (Read-Host "Enter the users you want to remove. Separate users with commas.").split(",").trim(),
[switch]$log)

if($log)
{
    do{
    $logPath = Read-Host "Enter the path where the log should be created"


        $testPath = Test-Path $logPath -IsValid
        if($testPath -eq $false)
        {Write-Warning "The path specified is invalid"}
    }
    until($testPath -eq $true)

}

$cred = Get-Credential -Message "Enter your login to authorize the operation"

$ADusers | ForEach-Object { 
    if($_ -notin (Get-ADUser -Filter *).samaccountname)
    {
        Write-Warning "Users account $PSitem doesn't exist."
    }

    else 
    {
        try
        {
        #Executing command
        Remove-ADUser -Identity $_ -Verbose -Credential $cred
        Write-Host "User $_ was deleted from the domain" -ForegroundColor Blue

        if($log)
        {
            Write-Output "$_" | Out-File $logPath -Append
        }
        }

        catch
        {Write-host "You are not authorized to perform the operation" -ForegroundColor Red}

    }  
}

if($log)
{Write-Host "Log with deleted accounts is in $logPath" -ForegroundColor Green}
