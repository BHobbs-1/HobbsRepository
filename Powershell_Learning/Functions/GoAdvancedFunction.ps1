<#
    .SYNOPSIS
        Placeholder for now
    
    .PARAMETER ComputerName
    The remote computer(s) to check the status of the services on.

    .EXAMPLE
        Dot source to reference code defined in one script in a separate one
        . .\GoAdvancedFunction
        Ping-Connection -ComputerName $vm

    .NOTES
         Author: Brian Hobbs
#>
function Ping-Connection {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )

    PROCESS {
        foreach ($Computer in $ComputerName) {
            try {
                Test-Connection -IPv4 -Ping -ResolveDestination $Computer 
            }
            catch {
                Write-Warning -Message "Unable to connect to Computer: $Computer"
            }
        }
    }

}