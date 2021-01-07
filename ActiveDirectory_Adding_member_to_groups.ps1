<#
.SYNOPSIS
This script adds AD members to specific groups.

.DESCRIPTION
We can use the script to add existing member to particular groups in the domain environment.
To run this script you need to have PS Active Directory modul.

.PARAMETER Member
Specifies the member to add to groups.

.PARAMETER GroupName
Specifies the names of the groups to which the AD member is to be added.

.EXAMPLE
.\ActiveDirectory_Adding_member_to_groups.ps1 -member user1 -groupname group1
#>


Param(
    [string]$Member = (Read-Host "Enter the user to be added to the AD group[s]"),
    [array]$GroupName = ((Read-Host "Enter a name for the group[s]") -split ",").trim()
    )

#Save credentials
$cred = Get-Credential -Message "Enter your login to authorize the operation"

#Checking if user exists in AD
try
{
    write-host "User $((Get-ADUser $Member).samaccountname) exist in domain`n" -ForegroundColor Blue -ErrorAction Stop
}
catch{Write-Host "User $Member doesn't exis in domain. You will exit the program." -ForegroundColor Red;exit}

#Check if AD group exists
foreach($G in $GroupName)
{
    try
    {
        Write-Host "`nGroup $((Get-ADGroup $G).name) exist in domain" -ForegroundColor Blue -ErrorAction Stop
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
    {Write-Host "`nGroup $G doesn't exist in domain. You will exit the program." -ForegroundColor Red;exit}
}


#Executing command
foreach($G in $GroupName)
{
    try
    { 
        if($Member -in (Get-ADGroupMember $G).samaccountname)
        {Write-Host "`nUser $Member already belongs to the group $G" -ForegroundColor Yellow}
        else 
        {
            Add-ADPrincipalGroupMembership -Identity $Member -MemberOf $G -Credential $cred -ErrorAction stop
            Write-Host "`nMember $Member was added to the group $G" -ForegroundColor Green
        }
    }
    catch
    {Write-Host "You are not authorized to perform the operation" -ForegroundColor red;exit}
}
