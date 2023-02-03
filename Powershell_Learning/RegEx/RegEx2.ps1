
Return "This is a walkthrough demo script file"

#region Creating a regex object

#pattern to match wordcharacters followed by a dash then 1-3 numbers
#note the use of anchors
[regex]$rx = "^[a-zA-Z]+-\d{1,3}$"
$rx
$rx | Get-Member

#endregion

#region Match

#test
$rx.IsMatch("foo-12")
$rx.IsMatch("BAR-1234")

#get
$rx.Match("SRV-01")
$rx.Match("SRV-01").Value

$names = "foo-12","fail","srv-02","ok-123","p!s-98","SRV-9999"
$names | Where-Object {$rx.IsMatch($_)}
#or find the notmatch
$names | Where-Object {-not $rx.IsMatch($_)}

#this would also work using the operator
$names | Where-Object {$_ -match $rx}
$names | Where-Object {$_ -notmatch $rx}
#we will look at Matches() method and using matches in the next module

Clear-Host

#endregion

#region Splitting

<#
# demo setup
$path = "C:\Data"
mkdir $path
$items = "Sales","Marketing","IT","Executive","Finance","HR","Accounting","Mfg"

1..50 | foreach-object {
  $h = Get-Random -Maximum 25000 -Minimum 1001
    $r = (Get-Date).AddMinutes(-$h)
  $t =  ($items|Get-Random)
  $f = "{0}{1}.dat" -f $h,$t
  $p = Join-Path -path $path -child $f
  
  1..1000 | Get-Random -Count (Get-Random -min 100 -max 1000) | Out-File $p
  $n = Get-Item $p
  $n.LastAccessTime = $r
  $n.CreationTime = $r
  $n.LastAccessTime = $r
  $n.LastAccessTimeUTC = $r.toUniversalTime()
  $n.CreationTimeUtc = $r.ToUniversalTime()
  $n.LastWriteTimeUtc = $r.toUniversalTime()
}
#>

Get-ChildItem -path C:\data
[regex]$rx = "\d+"
#splitting options
$rx.split.OverloadDefinitions

#proof of concept
$base = Get-ChildItem -path C:\data -file| Select-Object -first 1 -Property basename
$base
$rx.Split($base.BaseName)

#split on allfiles and group on the result
$rx.split((dir c:\data -file).basename) | Group-Object -NoElement

#splitting always includes an empty result
#trim where possible
$rx.split((Get-Childitem -path c:\data -file).basename).trim() | 
Where-Object {$_ -match "\w+"} | 
Group-Object -NoElement | 
Sort-Object Count -Descending

Clear-Host

#using the -split operator
$f = Get-ChildItem -path C:\data -file | Select-Object -First 1
$f.BaseName -split "\d+"

(Get-Childitem -path c:\data -file).basename -split "\d+" | 
Where-Object {$_ -match "\w+"} | 
Group-Object -NoElement | 
Sort-Object Count -Descending

help about_split

Clear-Host

#strings and the Split method
$t = "abcDEFhijDEFklm"

#using the -split operator
$t -split "DEF"
$t -split "def"

#the string object has a Split() method
$t.Split.OverloadDefinitions
$t.Split("def")
$t.Split("DEF") 
#trim out blanks
$t.Split("DEF") | where-object {$_ -match "\S+"}

#be careful
$f.basename
#not this
$f.basename.split("\d+")
#ok
$f.basename -split "\d+"
#again, filter out blanks
$f.basename -split "\d+" | where-object {$_ -match "\S+"}

Clear-Host
#case can also be an issue
$sample = "123Z456"
$sample.split("z")
$sample -split "z"
#$this could also work
$sample.split("[Zz]")

#a more practical example
Clear-Host

#proof of concept to get a version number. Saving result to variable C
Get-WindowsCapability -online -Name XPS* | Tee-Object -Variable c

<#
Name         : XPS.Viewer~~~~0.0.1.0
State        : NotPresent
DisplayName  : XPS Viewer
Description  : Allows you to read, copy, print, sign, and set permissions for XPS documents
DownloadSize : 3551681
InstallSize  : 16461846
#>

$c.Name
$c.name -split "~"
$c.name.split("~")
[regex]$rx = "~{4}"
$rx.split($c.name)

#try it out
Clear-Host
$items = Get-WindowsCapability -online | Where-Object {$_.name -notmatch "^Language"}
#sample
$items[1]

$all = foreach ($item in $items) {
 #need to get each item on its own to get the details
 Write-Host "Processing $($item.Name)" -ForegroundColor yellow
 $cap = Get-WindowsCapability -online -Name $item.name
 $split = $rx.split($item.name)
 [pscustomobject]@{
    Name = $split[0]
    Version = $split[1]
    Displayname = $cap.displayname
    Size = $cap.InstallSize
    State = $cap.State
    }
} 

$all | Out-GridView -title "Windows Capability"

Clear-Host

#endregion

#region Replacing

$t = "my secret text is Foo1234"
[regex]$rx = "\w+\d{4}"
$rx.Match($t)

$rx.Replace.OverloadDefinitions
$rx.Replace($t,"*****")
#I didn't change $t
$t

#or use the operator
$t -replace "\w+\d{4}","****"

#or method - but no pattern and case-sensitive
$t.Replace("Foo1234","****")

#a practical example
Clear-Host

<#
If you don't have any matching event you can use to test with
$s = Import-Clixml .\security.xml
#>

$s = Get-EventLog -LogName security -Newest 10 -InstanceId 4798
#what we have now
$s[0].message

[regex]$rx = "((Account|Workstation) (Name|Domain):\s+)\S+"
#get multiple matches
$matches = $rx.Matches($s[0].message)
$matches
$rx.Replace($s[0].message, "REDACTED")

#let's be a bit more elegant
Clear-Host
$matches[0].value
$matches[0].groups

#make a copy of the message
$text = $s[0].Message

#get all the matches
$matches = $rx.Matches($text)

#replace the names
foreach ($item in $matches) {
    $find = $item.groups[0].value
    Write-Host "Find `t`t $find" -ForegroundColor yellow
    $replace = "$($item.groups[1].value)******"
    Write-Host "Replace `t $replace" -ForegroundColor Green
    #the replace operator didn't like the $ at the end of names
    $text = $text.Replace($find, $replace)    
}

$text

#update all the data
Clear-Host
#get all property names except Message
$s = Get-EventLog -LogName security -Newest 10 -InstanceId 4798
#create an array of property names for the event log object other than Message
[object[]]$props = ($s[0] | Get-Member -MemberType Properties).Name | Where-Object {$_ -ne 'Message'}

#add the custom property to overwrite message using a value to be
#calculated later
$props+=@{Name="Message";Expression={$revised}}

#get the type name so you can re-use it
#System.Diagnostics.EventLogEntry
$objType = $s[0].getType().FullName

#update the output
$out = foreach ($entry in $s) {
    $matches = $rx.Matches($entry.message)
    $revised = $entry.message
    foreach ($item in $matches) {
        $find = $item.groups[0].value
        $replace = "$($item.groups[1].value)*****"
        $revised= $revised.Replace($find, $replace)
     }

     # write a copy of the object to the pipeline
     # since the Message property is read-only
     
     $entry | Select-Object $props
  
}
#re-add the typename sor formatting works as expected
($out).foreach({$_.psobject.TypeNames.Insert(0,$objType)})

#display the results
$out
$out.message

Get-Help about_Comparison_Operators 
Clear-Host

#endregion

#region regex options

# https://docs.microsoft.com/en-us/dotnet/api/system.text.regularexpressions.regexoptions?view=netframework-4.8

[enum]::GetNames([System.Text.RegularExpressions.RegexOptions])

#how you might create a regex object without the type accelerator
[System.Text.RegularExpressions.Regex]::new

#this pattern has limitations
[regex]$r = "^dom\d+"
$r
$r.IsMatch("dom1")
$r.IsMatch("DOM1")

#recreate the regex and make it case-insensitive
$r = [System.Text.RegularExpressions.Regex]::new("^dom\d+","ignoreCase")
$r
$r.IsMatch("dom1")
$r.IsMatch("DOM1")

#you can still use the type accelerator
$rg = [regex]::new("^dom\d+","ignoreCase")
$rg
$rg.Match("dOM2")

#your other option is to create a pattern that takes case into account
Clear-Host

#endregion