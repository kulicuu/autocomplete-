




#   Burkhard Keller
# BKTree and spellcheck

## architecture:

- NodeJS server with websockets (primus). Redis used for caching structure and could crawl it instead of NodeJS memory for the search process also.

## api characteristics

Since we don't have clients, the only client is the dev-client brujo-terminal. in this we have admin responsibilities, including loading different libraries, changing the parameters of the search (returning single word or a set of close matches)

Create, Read, Update, and Delete libraries.  These are text files.  These will be cached in Redis on a hash.


### Library Data Class

Base hash with library name, filename, path, id, datetime created, maybe name of algo structure it implements,


```coffeescript
lib_hash =
    name: "<string>"
    filename: "<string>"
    path: "<string>"
    id: "<string>"
    datetime_created: "<datestring>"
    algo_name: "<string>"   # some description
    file_contents_raw: "<string>"  # string file contents
    root_node: "<string>"  # uuid reference
```


### user-story process of loading a library

push button in terminal to load a dictionary file.  this calls websocket to server which calls fs reamiddir for the contents.  the contents are listed, one filename is chosen,
websocket again to server which loads the file to a string var and, then ...
We could just automatically apply the default algo to it.  It would be better maybe just to keep the raw file on hand cached, as a raw dictionary list of words.

Then another level of library would be a dictionary rendered to a specified data structure, by some algo or implementation of the algo.

#### user-story process of reading a library:

user hits button on client to browse library.  it would seem there are two levels now to browse, raw lists libraries, and parsed data-structures libraries.  hashes and sets in redis.

selecting a particular raw list dictionary would yield a list browse situation on the client bt.  

selecting a parsed tree structure dictionary would yield an svg generated graphical interface for browsing that structure.



#### user-story process of searching

the client implementation has responibility for and can decide how to present it, am thinking it will be a box that selects lib and structure probly separate inputs for the autocorrect and spellcheck, but then there could be composites, i guess that would search both and have some kind of integrated display of results.

As now, these searches are sent by websockets.


The searches could be over the NodeJS process memory structure or it could be an implementation over some redis transactions.  It could also be internalised to Redis via Lua scripting.


#### list functions
