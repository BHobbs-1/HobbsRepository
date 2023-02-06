# CmdletBinding attribute: 
# --Add basic cmdlet features, such as common parameters, to functions 
# --Make certain methods available that allow you to change the behavior of the function.
Function Copy-OneTwo {
    Param(
            [Parameter(Mandatory=$True,
                      Position=0)]
            [String]$Source,
            [Parameter(Mandatory=$True,
                      ParameterSetName="OneDestination")]
            [String]$Destination,
            [Parameter(Mandatory=$True,
                      ParameterSetName="TwoDestinations")]
            [String]$Destination1,   
            [Parameter(Mandatory=$True,
                      ParameterSetName="TwoDestinations")]
            [String]$Destination2
         )
     switch ($PsCmdlet.ParameterSetName){
        "OneDestination"   { Copy-Item -Recurse $Source $Destination } 
        "TwoDestinations"  { Copy-Item -Recurse $Source $Destination1; Copy-Item $Source $Destination2 }
     }
}