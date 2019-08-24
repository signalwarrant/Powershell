<#
    .SYNOPSIS
        Gets the members of the local administrators of the computer and 
        outputs the result to a CSV file. 

    .REQUIREMENTS
        None that I know of.

    .LINK
        Source script: https://gallery.technet.microsoft.com/223cd1cd-2804-408b-9677-5d62c2964883

    .Parameter
        $Computers: Computer names of devices to query 
        
    .EXAMPLE
        Get-LocalAdmins -Computers CL1,CL2
        Get-LocalAdmins -Computers (Get-Content -Path "$env:HOMEPATH\Desktop\computers.txt")
        Get-LocalAdmins -Computers DC,SVR8 | Format-Table -AutoSize -Wrap
        Get-LocalAdmins -Computers DC,SVR8 | Export-Csv -Path "$env:HOMEPATH\Desktop\LocalAdmin.csv" -NoTypeInformation
#>


Function Get-LocalAdmins {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [string[]]$Computers
        )
    # testing the connection to each computer via ping before
    # executing the script
    foreach ($computer in $Computers) {
        if (Test-Connection -ComputerName $computer -Quiet -count 1){
            Add-Content -value $computer -path $env:USERPROFILE\AppData\Local\Temp\livePCs.txt -Force
        }else{
            Write-Verbose -Message "$computer is unreachable" -Verbose
        }
    }

    $liveComputers = Get-Content -Path $env:USERPROFILE\AppData\Local\Temp\livePCs.txt

    $list = new-object -TypeName System.Collections.ArrayList
    foreach($computer in $liveComputers){
        $admins = Get-WmiObject win32_groupuser -ComputerName $computer | Where-Object {$_.groupcomponent –like '*"Administrators"'} 
        $obj = [pscustomobject]@{
            ComputerName = $computer
            LocalAdmins = $null
        }
        ForEach($admin in $admins){
            $admin.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” | out-null 
            $matches[1].trim('"') + “\” + $matches[2].trim('"') + "`n" | out-null
            $obj.Localadmins += $matches[1].trim('"') + “\” + $matches[2].trim('"') + "`n"
        }
        $list.add($obj) | Out-Null
    }
    $list

    # Cleaning up the txt files 
    if(Test-Path -Path $env:USERPROFILE\AppData\Local\Temp\livePCs.txt){
        Remove-Item -Path $env:USERPROFILE\AppData\Local\Temp\livePCs.txt -Force
    }
}
