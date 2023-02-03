
 <#
.Synopsis
Display Select-String context
.Description
Show context results from a Select-String match. It is assumed you specified context with Select-String. The default output is a formatted list or you can use the -Context parameter to show context using Write-Host. When using -Context matched content will be displayed in green. Pre and Post context will be displayed in yellow.
.Parameter ContextOnly
Show context only using colorized output with Write-Host. This parameter will not write anything to the pipeline.
.Example
PS C:\> dir trans-2.txt | select-string set-service -Context 0,2 | Show-Context

   Filename: trans-2.txt


LineNumber : 49
Pre        :
Line       : PS C:\work> get-service xb* | set-service -StartupType Disabled -PassThru | select name,starttype
Post       :
             Name           StartType


LineNumber : 727
Pre        :
Line       : Cmdlet          Set-Service                              3.1.0.0    Microsoft.PowerShell.Management
Post       : Cmdlet          Set-SPOBrowserIdleSignOut                16.0.89... Microsoft.Online.SharePoint.PowerShell
             Cmdlet          Set-SPOBuiltInDesignPackageVisibility    16.0.89... Microsoft.Online.SharePoint.PowerShell
.Example
PS C:\> dir trans-2.txt | select-string set-service -Context 0,2 | Show-Context -contextonly

trans-2.txt
-----------
[49]   PS C:\work> get-service xb* | set-service -StartupType Disabled -PassThru | select name,starttype
[50]
[51]   Name           StartType
[727]  Cmdlet          Set-Service                                        3.1.0.0    Microsoft.PowerShell.Management
[728]  Cmdlet          Set-SPOBrowserIdleSignOut                          16.0.89... Microsoft.Online.SharePoint.PowerShell
[729]  Cmdlet          Set-SPOBuiltInDesignPackageVisibility              16.0.89... Microsoft.Online.SharePoint.PowerShell

Displays colorized context output using Write-Host.
.Link
Select-String

.Notes
Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

.Inputs
[Microsoft.PowerShell.Commands.MatchInfo]

#>
Function Show-Context {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [Microsoft.PowerShell.Commands.MatchInfo]$Inputobject,
        [switch]$ContextOnly
    )
    Begin {
        $data = @()
    }
    Process {
        $data += $Inputobject
    }
    end {
        $data = $data | Sort-Object -Property Filename, LineNumber

        if ($ContextOnly) {

            $grouped = $Data | Group-Object -Property Filename
            foreach ($file in $grouped) {
                Write-Host "`n$($file.name)" -ForegroundColor cyan
                Write-Host $("-" * $($file.name.length)) -ForegroundColor Cyan
                foreach ($item in $file.group) {
                    if ($item.context.precontext) {
                        $l = $item.linenumber
                        foreach ($pre in $item.context.precontext) {
                            $l--
                            $leader = $("[$l]").Padright(6, ' ')
                            Write-Host "$leader $($pre.trim())" -ForegroundColor yellow
                        }
                    }

                    $leader = $("[$($item.linenumber)]").Padright(6, ' ')
                    Write-Host "$leader $($item.line.trim())" -ForegroundColor green

                    if ($item.context.postcontext) {
                        $l = $item.linenumber
                        foreach ($post in $item.context.postcontext) {
                            $l++
                            $leader = $("[$l]").Padright(6, ' ')
                            Write-Host "$leader $($post.trim())" -ForegroundColor yellow
                        }
                    }

                } #foreach item
            } #foreach file

        } #if $contextonly
        else {
            #write formatted data to the pipeline
            $data | Format-List -GroupBy Filename -Property LineNumber, @{Name = "Pre"; Expression = { $_.Context.precontext | Out-String } },
            Line, @{Name = "Post"; Expression = { $_.Context.postcontext | Out-String } }
        }
    }

}