# Grouped list of Methods
[math].GetMethods() | Group-Object -Property Name
# Details on "round" Methods
[math]::round.OverloadDefinitions

# Testing by creating an Mathmatical varible
$num = 1.273
$Round1 = [math]::round($num,1)
$Round2 = [math]::round($num,2)
write-host "1 decimal places should round up from "1.273" to $Round1"
write-host "2 decimal places should drop the other decimal places from "1.273" to $Round2"

# Convert to GB and round to an integer
54598225634/1gb -as [Int32]