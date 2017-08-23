



# NOTE:  To construct a BKtree like
# https://nullwords.wordpress.com/2013/03/13/the-bk-tree-a-data-structure-for-spell-checking/
# for spell check.  also define the seaorch function here.


# NOTE copy translating out of C into CoffeeScript . at the same time from class pattern to functional
# composition pattern.  ...[edit ] though it's kind of a mess at the moment, not in a bad way but
# it's an intermediate pattern.  function composition with some shared scope vars mutated.


# bktree :   add word
#               search   word
#                  recursive_search    node, rtn, string_word, delta
#                       lev_d : imported
#

# node  :
#           constructor
#           keys_return
#           add_chd


fs = require 'fs'
_ = require 'lodash'
c = console.log.bind console



lev_d = require('./levenshtein_distance.coffee').default













# node
node_f = ({ word }) ->
    word: word
    chd_nodes: {}


# node
keys_collect = ({ node }) ->


# operate on node with key
contains_key = ({ node, key }) ->
    if _.includes(_.keys(node.chd_nodes), key)
        return true
    else
        return false


# operate on node
add_chd_to_node = ({ node, key, word }) ->
    node.chd_nodes[key] = node_f { word }


exports.tree_add_word = tree_add_word = ({ bktree, word }) ->
    if bktree.root is null
        bktree.root = node_f({ word })
        return { bktree }
    cur_node = bktree.root
    delta = lev_d cur_node.word, word
    while _.includes(_.keys(cur_node.chd_nodes), '' + delta)
        if delta is 0
            return { bktree }
        cur_node = cur_node.chd_nodes[delta]
        delta = lev_d cur_node.word, word
    add_chd_to_node
        node: cur_node
        key: delta
        word: word

    { bktree }










cursive_search_001 = (node, rayy, word, delta) ->
    cur_delta = lev_d node.word, word
    min_delta = cur_delta - delta
    max_delta = cur_delta + delta

    if cur_delta <= delta
        rayy.push node.word

    c node, '\n'
    c cur_delta, 'cur'
    the_keys = _.keys(node.chd_nodes)
    # c the_keys
    # c _.includes(the_keys, '' + cur_delta)
    if (the_keys.length > 0) and (_.includes(the_keys, '' + cur_delta))
        delta_node = node.chd_nodes[cur_delta]
        # c delta_node, '111'
            # add_node({bktree})

        rayy.push delta_node.word
        _.forEach delta_node.chd_nodes, (node2, key) ->
            cursive_search_001 node2, rayy, word, delta
    return rayy





search = ({ bktree, word, delta }) ->
    word = word.toLowerCase()
    rtn = cursive_search_001 bktree.root, [], word, 1
    c rtn, 'rtn'



load_100 = Bluebird.promisify ({ filename }, cb) ->
    the_blob = fs.readFile path.resolve



"parse_blob_make_data_structure:"
load_func_2064 = Bluebird.promisify ({ blob }, cb)->
    d1 = blob.split '\n'
    bktree = { root: null }
    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()
    for word, idx in d1
        unless word.length is 0
            c "#{color.green('Adding word: ', on)} #{color.cyan(word, on)}"
            { bktree } = tree_add_word
                bktree: bktree
                word: word
            c "#{color.blue('Done.', on)}"
    { bktree }



load_func = ->
    blob_1 = fs.readFileSync '../dictionaries/reduced_000.txt', 'utf8'
    blob_2 = fs.readFileSync '../dictionaries/rdc_003.txt', 'utf8'
    blob_3 = fs.readFileSync '../dictionaries/d1.txt', 'utf8'
    blob_4 = fs.readFileSync '../dictionaries/reduced_a_.txt', 'utf8'

    d1 = blob_4.split '\n'

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

    # c bktree.root
    # c '\n'
    # c bktree.root.chd_nodes[4].chd_nodes


    # search
    #     bktree: bktree
    #     word: 'addresh'
    # for idx in [4 .. 12]
    #     c bktree.root.chd_nodes['' + idx]
    #     c bktree.root.chd_nodes['' + idx].chd


# load_func()







exports.default = load_func
    # c 'say hi'
