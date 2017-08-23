

# We want option feature to load dictionaries into nodejs memory and also into redis memory.


# We want the basic CRUD setup for all of those operations.

#  We could save trash as a kind of non-destructive thing behind the CRUD, with an option to flush it.

go_err = (err) ->
    c "#{color.red('there was an error.')}", err

# designing library data structure.  hash set list we could just make it a set of uids to hashes containing some meta info
# and then a reference to the root node.


# LIBRARY  # private, payload should be redacted for return to client.
get_library_contents_100 = Bluebird.promisify (cb) ->
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
                go_err err
                cb err
            else
                cb { lib_rayy: rayy }
    .error (e) ->
        go_err e




cursive_redis_add = (node, node_id) ->

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



load_bktree_to_redis = Bluebird.promisify ({ bktree, root_node_ref }, cb) ->

    cur_node = bktree.root
    cursive_redis_add cur_node

    # if _.keys(cur_node.chd_nodes).length > 0


search_over_redis_mem = Bluebird.promisify ({ bktree_id, word, delta }, cb) ->
    # Here we implement the search algo over Redis structure only without
    # building the data structure into NodeJS memory.



browse_d_ = Bluebird.promisify ({}, cb)->
    note_ = "We have a dictionary in some tree structure and we may want to browse a neighborhood, graphically, through the brujo-terminal."
    note_2 = "some kind of client side graphics solution with svg should be possible"
    note_3 = " what we need from the server side is just the json of a neighoborhood, some several layers of nodes"
    note_4 = "another browse might just be the words without trying to convey the
    tree structure.  in this case we may want to pass blocks similar to the way we would implement transferring a long chat timeline to a client app."



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




" what if there was a successful parse up to a point that got cut off , how would we restart the process ?"
"we would first have to recover it from redis.  "


" we could also just put it into redis to begin with and just forget about ever putting it into nodejs memory."



tree_add_word = require('./burkhard-keller_tree_300.coffee').tree_add_word

exports.parse_blob_to_mem = parse_blob_to_mem = ({ blob }) ->
    d1 = blob.split '\n'
    bktree = { root: null }
    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()
    for word, idx in d1
        unless word.length is 0
            c 'word loading', word
            { bktree } = tree_add_word
                bktree: bktree
                word: word
    { bktree }
    # " this is the func main for the new system."
