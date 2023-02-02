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

write-host("Remove key-value")
$hash.Remove("Updated")

write-host("print Size")
$hash.Count

write-host("sort by key")
$hash.GetEnumerator() | Sort-Object -Property key



# The Hashtable data structure is much like an array, except you store each value (object) using a key: 

# Creating an empty hashtable
$ArtistAgeTheyDied = @{}

# Add to HashTable: 
$key = 'Bob Ross'
$value = 52
$ArtistAgeTheyDied.add( $key, $value )

# Add more to HashTable like this: 
$ArtistAgeTheyDied.add( 'Chuck Close', 81 )
$ArtistAgeTheyDied.add('Salvador Dalí', 84 )