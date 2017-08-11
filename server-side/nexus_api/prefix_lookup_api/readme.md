



#### prefix lookup api



Given the user's typed word/partial word as a prefix, locate matching set of completions, or, alternatively, return the 'best' match.


Expected lookup time is O(L) where L is the length of the prefix.


The build of the tree is 'heavy', takes a lot of time, but then it's in memory and lookups are very fast.


We want to put the structure into Redis for some persistance on reloading.



#### Lookup api notes


Calls come into the server-side over websockets, then transferred to API calls on this system Lookup.

Responses from the API are synchronous.
