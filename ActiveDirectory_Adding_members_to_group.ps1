<#
.SYNOPSIS
This script adds the user[s] to an Active Directory group.

.DESCRIPTION
We can use the script to add existing members to particular group in the domain environment.

.EXAMPLE
.\ActiveDirectory_Adding_members_to_group.ps1
#>


#Name of group
$GroupName = Read-Host "Enter the name of the AD group"

#Check if group exists in Active Directory
if($GroupName -notin (Get-ADGroup -Filter *).name)
{Write-Host "Group $GroupName doesn't exist. You will exit the program." -ForegroundColor Red; exit}

#Members
$Members = ((Read-Host "Enter the members who are to belong to the group. Separate individual members with a comma.") -split ",").Trim()

#Check if members exist in Active Directory
foreach ($Member in $Members) 
{try
{
    write-host "User $((Get-ADUser $Member).samaccountname) exist in domain`n" -ForegroundColor Blue -ErrorAction Stop
}
catch{Write-Host "User $Member doesn't exis in domain. You will exit the program." -ForegroundColor Red;exit}
}

#Credentials
$cred = Get-Credential -Message "Enter your login to authorize the operation"

#Executing command
try
{
Add-ADGroupMember -Identity $GroupName -Members $Members -Credential $cred -ErrorAction Stop
Write-Host "User[s] $($Members -join ", ") added to group $Groupname. Total number of members added: $($Members.count)" -ForegroundColor Green
}
catch
{
Write-Host "You are not authorized to perform the operation" -ForegroundColor red
}

