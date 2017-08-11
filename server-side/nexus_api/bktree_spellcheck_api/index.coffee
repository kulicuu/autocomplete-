

# We want option feature to load dictionaries into nodejs memory and also into redis memory.


# We want the basic CRUD setup for all of those operations.

#  We could save trash as a kind of non-destructive thing behind the CRUD, with an option to flush it.



# designing library data structure.  hash set list we could just make it a set of uids to hashes containing some meta info
# and then a reference to the root node.


# LIBRARY  # private, payload should be redacted for return to client.
get_library_contents = Bluebird.promisify (cb) ->
    rayy = []

    iter = (lib_id, cb) ->
        redis.hgetallAsync lib_id
        .then (lib_hash) ->
            rayy.push lib_hash
            cb null
        .error (e) ->
            c "#{color.red('there was an error.')}"

    redis.smembersAsync "bktree_library_contents"
    .then (identities) ->
        control_flow.each identities, iter, (err) ->
            if err
                c "#{color.red('there was an error..883')}"
            else
                cb { lib_rayy: rayy }
    .error (e) ->
        c 'there was err', e






# CREATE
load_d = ({ bktree }) ->
    # given a bktree structure in nodejs memory, translate it into a redis data structure, and save a reference in a common library, also in redis.
    "give it an id."
    # We need a reference to a common library


    the_lib_id = v4()


    redis.hmset the_lib_id

    redis.saddAsync "bktree_library_contents", the_lib_id
    .then (re) ->

    .error (e) ->
        c 'err', err





retrieve_d = ->
    "given an id get the structure into nodejs memory structure."
