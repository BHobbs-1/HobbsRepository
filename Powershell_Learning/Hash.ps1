$hash = @{ ID = 1; Shape = "Square"; Color = "Blue"}

write-host("Print all hashtable keys")
$hash.keys

write-host("Print all hashtable values")
$hash.values

write-host("Get ID")
$hash["ID"]

write-host("Get Shape")
$hash.Number

write-host("print Size")
$hash.Count

write-host("Add key-value")
$hash["Updated"] = "Now"

write-host("Add key-value")
$hash.Add("Created","Now")

write-host("print Size")
$hash.Count



write-host("print Size")
$hash.Count





# The Hashtable data structure is much like an array, except you store each value (object) using a key: 

# Creating an empty hashtable
$HashArtistAge = @{}

# Add to HashTable: 
$key = 'Bob Ross'
$value = 52
$HashArtistAge.add( $key, $value )

# Add more to HashTable like this: 
$HashArtistAge.add( 'Chuck Close', 81 )
$HashArtistAge.add( 'Salvador Dalí', 84 )
$HashArtistAge.add( 'Marc Rothko', 66 )
$HashArtistAge.add( 'Jasper Johns', 92 )

<#
write-host("Remove key-value")
$HashArtistAge.Remove("Updated")
#>

write-host("sort by key")
$HashArtistAge.GetEnumerator() | Sort-Object -Property Name
write-host("sort by value")
$HashArtistAge.GetEnumerator() | Sort-Object -Property Value -Descending
