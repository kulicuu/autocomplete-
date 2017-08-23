

fs = require 'fs'


break_ties = ({ candides }) ->
    # for now will just return the first,
    # but later can implement the logic for lexicographic order
    candides[0]


map_prefix_to_match = ({ dictionary, prefix }) ->
    # c color.green prefix
    # c dictionary
    candides = []
    for word in dictionary
        if word.indexOf(prefix) is 0
            candides.push word
    if candides.length > 1
        return break_ties { candides }
    else
        return candides.pop()


load_tree_to_redis = ({}) ->
    lib_hash =
        name: "<string>"
        filename: "<string>"
        path: "<string>"
        id: "<string>"
        datetime_created: "<datestring>"
        algo_name: "<string>"   # some description
        file_contents_raw: "<string>"  # string file contents
        root_node: "<string>"  # uuid reference


# At some point there will be multiple dictionaries, but for now just the one.

lookup_tree_in_redis_by_prefix = ({ tree_id, prefix }) ->

load_tree_from_redis_to_mem = ->


delete_tree_from_redis = ->



cursive_redis_node_load_001 = ( the_node, node_id ) ->

    node_arq =
        word: the_node.word


    _.map the_node.chd_nodes, (chd_node, key) ->
        chd_id = v4()
        node_arq[key] = chd_id
        cursive_redis_node_load_001 chd_node, chd_id

    redis.hmset node_id, node_arq






load_tree_to_redis_001 = Bluebird.promisify ({ tree_name, tree }, cb) ->



load_tree_to_redis_000 = Bluebird.promisify ({ tree_name, tree }, cb) ->




    c "        #{color.blue('\n \n \n have tree \n \n \n', on)}"

    tree_id = v4()

    # chd_nodes_id = v4()
    redis.hset 'prefix_trees', tree_name, tree_id

    cursor = tree

    arq =
        word: cursor.word

    _.forEach cursor.chd_nodes, (chd, key) ->
        chd_id = v4()
        arq[key] = chd_id
        redis.hmset chd_id
            word: chd.word
            chd_nodes


    redis.hmset tree_id,
        word: cursor.word
        chd_nodes: chd_nodes_id









        # cb null, 'hello tree redis load re'



load_func = ->

    blob_1 = fs.readFileSync '../dictionaries/d1.txt', 'utf8'
    d1 = blob_1.split '\n'
    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()


    tree =
        chd_nodes: {}
        prefix: ''


    for word, idx in d1
        c "Building word: #{color.cyan(word, on)}"
        cursor = tree
        prefix = ''
        unless word.length < 1
            for char, jdx in word
                prefix+= char
                if not _.includes(_.keys(cursor.chd_nodes), char)
                    cursor.chd_nodes[char] =
                        match_word: map_prefix_to_match({ prefix, dictionary: d1 })
                        prefix: prefix
                        chd_nodes: {}
                cursor = cursor.chd_nodes[char]

    c "\n\n\n #{color.green('Done building cache tree.', on)} \n \n \n"

    load_tree_to_redis
        tree_name: 'first_prefix_tree'
        tree: tree
    .then (re) ->
        c "            #{color.green('\n \n \n have re from load redis .   \n \n \n ')}"
        c re
        c '... \n \n \n'

    { tree }



exports.default = load_func
