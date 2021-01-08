<#
.SYNOPSIS
Quickly check who is logged in on the remote computer in Active Directory environment.

.DESCRIPTION
The script allows you to quickly check who is logged in to the remote computer[s] on the domain network in which you are.
You must provide the name of the remote computer[s].
#>

#Enter Computers to check
[array]$computers = ((Read-Host "Enter the name of AD remote computer[s]") -split ",").Trim()

#Checking the availability of computers
foreach ($c in $computers) {

    #Checking if computers exist in the domain
    if ($c -notin (Get-ADComputer -Filter *).name) {
        write-host "Computer $c does not exist in the domain. Please remove the computer from the list and run the program again`n" -ForegroundColor Red; pause; exit
    }
    else {
        Write-Host "Computer $c is in the domain" -ForegroundColor Green
    }
    
    #Checking if the computer is online
    $testCon = Test-Connection $c -Count 2 -Quiet

    if ($testCon -eq $false) {
        Write-Host "Computer $c not responding. Please remove the computer from the list and run the program again`n" -ForegroundColor Red; pause; exit
    }

    write-host "Computer $c is online`n" -ForegroundColor Green
}

#Executing command
$computers | ForEach-Object {Write-Host "`n $_" -ForegroundColor green; Invoke-Command -ComputerName $_ -ScriptBlock {quser}}