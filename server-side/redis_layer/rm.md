



>- lookup-redis-api.  move all redis calls out of everything and into here.  is that actually always a good idea ?
this could include building data structures, keeping track of library, etc.  this could also mean building nodejs structures out of cached redis data-structures.



redis-layer includes many things including caching in support of nodejsmem services, but lookup-redis should follow the structure of lookup-nodejsmem pretty much.
