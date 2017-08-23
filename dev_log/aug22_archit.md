







### ---


Realising there was some confusion with so many possibilities for architecture and the implementation history, and no strategy on the gui concept, so setting out to look at the architectural possibilities.



Was just now thinking it would be interesting and cool to this structure featuring effectively stateless nodejs server(s) with (shared) redis memory, and running even the whole parsing and search routines internally to redis in lua.

but already have a the implementations done for the operations on the nodejs memory data-structures.

but need redis still for cachining of built data-structures, because the data-structure builds are heavy expensive for real-world dictionaries.

my units of construction are what i call apis: related, somewhat pure functions packed into an object accessed by a function acting as gateway.  type & payload system.  the pattern allows for the components to be made functionally pure and independent, although in prototyping it's freeform and i'm not using immutables but rather closures and imperative patterns internally.

this aids separation of concerns and offers transformer-like quick configurability in and out of various operating contexts including development, staging etc of various configurations.  the system could be wrapped into a node module where the consumer was responsible for providing the dictionary.  the system could be turned into a global scalable node/redis quicksearch (ie spellcheck autocomplete) production unit.  

the brujo-terminal is fun, need to make a gui idea.  also was looking to build in some graph traversing (svg or webgl) user interface.  they could type into the box and navigate the nodes ?  



#### api list:
_conjecture:_


- primus-layer (more a module):  handles connections passing of spark:: currently this is stashed in dev-server.


- brujo-layer-api:  handles everything the bt client could want, which is a superset of the standard consumer interface, and includes administrative as well as development tooling.  _open ended possibilities but likely just implement a few ideas_
     is kind of a controller.  delegates to other apis

- lookup-redis-api.  move all redis calls out of everything and into here.  is that actually always a good idea ?
this could include building data structures, keeping track of library, etc.  this could also mean building nodejs structures out of cached redis data-structures.

- lookup-nodejsmem-api:  doing the stuff in nodejs memory, meaning building the data-structures in nodejs



- then finally at a fairly low-level we have separate apis for each data-structure type, separately for redis and nodejsmem implementations.  in redis may want to go ahead and skip straight to lua without prototyping over a plain redis (node-redis) api high-transaction implemantation.




#### brujo-terminal


minimalist structure as follows:

collect the names of the raw dictionaries and the algos available into a matrix / table / spreadsheet layout
#### pane 0 main admin spreadsheet / control-panel
each cell will indicate if there is something already cached and built on that, if it's cached is it in redis mem or nodejs mem ?  a feature, maybe offer to make different versions so could diff the structures.  this indicates a server side tree crawling system that will diff data-structures.  also a button for selecting active structure for text entry

a panel for text entry and search result presentation
#### pane 1  :: text entry and search results display
if there is a data structure available and selected (maybe can select more than one and then aggregate results) then text entry in this pane induces immediately in a results sub-pane the search results

graph analysis pane, graphics !
#### pane 2   :: more later
given selectwion in pane0 and text in pane2, the interactive graphics in pane2 allows for visually traversing tree by node. in a much smaller sub-pane, which will hide from view when not in use, any graph diffy results info may be displayed.  super advanced: display in graphics pane both trees superimposed, could be interesting to assess diff visually.



#### development plan

for bt, just pane0 and pane1 necessary for first stage.


for server-side, only the redis parts necessary for caching of nodejs memory structures, and retrieving them, are necessary now.  the algos for nodejsmem implementation is done just development had no archi concept up until now, lots of ideas and no organisation.
