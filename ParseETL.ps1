<# 
There is no built in command for reading an etl file with PowerShell but calling tracerpt.exe in windows\system32 for converting the etl file into xml (the file is always called dumpfile.xml) 
seems to be a simple solution:
#>
$WuPath = "C:\Windows\Logs\WindowsUpdate" 
$WuFile = "WindowsUpdate.*.etl"
Get-ChildItem -Path $WuPath -File $WuFile

# Create "-lr" (Less restrictive; use best effort for events not matching event schema) dumpfile.xml
C:\windows\system32\tracerpt.exe C:\Windows\Logs\WindowsUpdate\WindowsUpdate.20230125.102929.852.10.etl -lr
# Structure of XML
([Xml](Get-Content .\dumpfile.xml)).Events
# First Level
C:\([Xml](Get-Content .\dumpfile.xml)).Events.Event | Format-Table -AutoSize
# Discriptions and more
([Xml](Get-Content .\dumpfile.xml)).Events.Event.EventData.Data | Format-Table -AutoSize
# Get Time
([Xml](Get-Content .\dumpfile.xml)).Events.Event.System.TimeCreated | Format-Table -AutoSize
# Get running task
([Xml](Get-Content .\dumpfile.xml)).Events.Event.RenderingInfo.Task | Format-Table -AutoSize
<# 
<ElementType>.<AttributeType>.<attribute>.<element>
 https://adamtheautomator.com/powershell-parse-xml/
 ## Select-Xml -Path .\dumpfile.xml -XPath '/Events/Event/EventData/Data' | ForEach-Object { $_.Node.name }
 #>


# Casting XML Strings to Objects.  By prefixing the variable names with [xml], PowerShell converts the original plain text XML into objects.
[xml]$xmlTest = Get-Content -Path .\dumpfile.xml
$xmlTest.ChildNodes.Event | Format-Table -AutoSize
# 1st level:  xmlns, System, EventData, RenderingInfo, ExtendedTracingInfo
$xmlTest.ChildNodes.Event.System  | Format-Table -AutoSize
# 2nd level System:  Provider, EventID, Version, Level, Task, Opcode, Keywords, TimeCreated, Correlation, Execution
# 2nd level EventData:  

<#
    Select-Object -InputObject $xmlTest.Events.Event.System.Level
    select-Object -InputObject $xmlTest.Events.Event.EventData.Data
#>

# empty Array
$arr = @()
# add to array 
$arr += 100
$autoArr = 1..5

# Hash Table
$hash = @{Name = "Jeff", Name = "Marc",}

# Version control in VS Code
https://code.visualstudio.com/docs/introvideos/versioncontrol