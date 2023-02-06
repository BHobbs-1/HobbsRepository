# CmdletBinding attribute: 
# --Add basic cmdlet features, such as common parameters, to functions 
# --Make certain methods available that allow you to change the behavior of the function.

Function GoVerbose {
    [CmdletBinding()]Param()
    Write-Verbose "Alright, you prefer talkative functions. First of all, I appreciate your wish to learn more about the common parameter -Verbose. Secondly, blah blah.."
    Write-Host "This is self-explanatory, anyway."
}
GoVerbose