<#
.SYNOPSIS
Script for quick search of active IP addresses via ICMP protocol for Mask: /24

.DESCRIPTION
The script allows you to quickly search for active IP addresses within a specified range.
Should be given:
- network address without the last octet
- starting IP address
- final IP address
#>


#IP Address
$IPNetAddr = Read-Host "Enter the network IP address (without the last oket) according to the pattern: X.X.X"
$IPAddrStart = Read-Host "Enter the starting IP address"
$IPAddrEnd = Read-Host "Enter the end IP address"
$range = $IPAddrStart..$IPAddrEnd
Write-Host "Active IP addresses:"
$range | ForEach-Object {
    $testConn = Test-Connection $IPNetAddr"."$_ -Count 1 -Quiet

    if($testConn -eq $true)
    {
        Write-Host "$IPnetaddr.$_"
    }
}