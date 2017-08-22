







### ---


Realising there was some confusion with so many possibilities for architecture and the implementation history, and no strategy on the gui concept, so setting out to look at the architectural possibilities.



Was just now thinking it would be interesting and cool to this structure featuring effectively stateless nodejs server(s) with (shared) redis memory, and running even the whole parsing and search routines internally to redis in lua.

but already have a the implementations done for the operations on the nodejs memory data-structures.

but need redis still for cachining of built data-structures, because the data-structure builds are heavy expensive for real-world dictionaries.

my units of construction are what i call apis: related, somewhat pure functions packed into an object accessed by a function acting as gateway.  type & payload system.  

this aids separation of concerns and offers transformer-like quick configurability in and out of various operating contexts including development, staging etc of various configurations.  the system could be wrapped into a node module where the consumer was responsible for providing the dictionary.  the system could be turned into a global scalable node/redis quicksearch (ie spellcheck autocomplete) production unit.  

the brujo-terminal is fun, need to make a gui idea.  also was looking to build in some graph traversing (svg or webgl) user interface.  they could type into the box and navigate the nodes ?  
