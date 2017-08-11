

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




cursive_redis_add (node, node_id) ->

    # TODO make this asyncy

    chd_nodes_id = v4()

    node_hash =
        word: node.word
        chd_nodes: chd_nodes_id

    # redis.sadd chd_node_set_id, _.keys(node.chd_nodes)

    redis.hmsetAsync node_id, node_hash

    _.forEach node.chd_nodes, (chd_node, key) ->
        chd_node_id = v4()
        redis.hset chd_nodes_id, key, chd_node_id
        cursive_redis_add chd_node, chd_node_id



actual_load_d = Bluebird.promisify ({ bktree, root_node_ref }, cb) ->

    cur_node = bktree.root



    cursive_redis_add cur_node

    # if _.keys(cur_node.chd_nodes).length > 0





# CREATE
load_d = ({ bktree, name, description, filename, path }) ->
    # given a bktree structure in nodejs memory, translate it into a redis data structure, and save a reference in a common library, also in redis.
    # We need a reference to a common library




    the_lib_id = v4()
    the_root_node_ref = v4()


    redis.hmsetAsync the_lib_id,
        lib_id: the_lib_id
        name: name
        description: description
        filename: filename
        path: path
        root_node_ref: the_root_node_ref



    redis.saddAsync "bktree_library_contents", the_lib_id
    .then (re) ->

    .error (e) ->
        c 'err', err





retrieve_d = ->
    "given an id get the structure into nodejs memory structure."
