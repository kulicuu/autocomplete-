



# NOTE:  To construct a BKtree like
# https://nullwords.wordpress.com/2013/03/13/the-bk-tree-a-data-structure-for-spell-checking/
# for spell check.  also define the seaorch function here.


# NOTE copy translating out of C into CoffeeScript . at the same time from class pattern to functional
# composition pattern.


fs = require 'fs'
_ = require 'lodash'
c = console.log.bind console



lev_d = require('./levenshtein_distance.coffee').default









# bktree :   add word
#               search   word
#                  recursive_search    node, rtn, string_word, delta
#                       lev_d : imported
#

# node  :
#           constructor
#           keys_return
#           add_chd



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
    { node }



counter = 0

# tree
tree_add_word = ({ bktree, word }) ->
    c counter++
    if bktree.root is null
        bktree.root = node_f({ word })
        c bktree
        return { bktree }

    cur_node = bktree.root
    c cur_node
    c bktree

    delta = lev_d cur_node.word, word
    while _.includes(_.keys(cur_node), delta)
        if delta is 0 then return { bktree }

        cur_node = cur_node[delta]
        delta = lev_d cur_node.word, word

    { node } = add_chd_to_node
        node: cur_node
        key: delta
        word: word
    cur_node[delta] = node

    { bktree }









cursive_search_001 = ({ node, bktree, word, delta}) ->
    cur_delta = lev_del node.word, word
    min_delta = cur_delta - delta
    max_delta = cur_delta + delta

    if cur_delta is delta
        add_node({bktree})



# not recursive version levenshtein distance
lev_del = ({ s, t }) ->
    len_s = s.length
    len_t = t.length
    if len_s is 0 then return len_t
    if len_t is 0 then return len_s



    # d = [len_s + 1, len_t + 1]
    matrix = []
    for idx in [0 .. len_s]
        matrix[idx] = []
        for jdx in [0 .. len_t]
            matrix[idx][jdx] = 'void'


    for idx in [0 .. len_s]
        matrix[idx][0] = idx

    for jdx in [0 .. len_t]
        matrix[0][jdx] = jdx

    for idx in [1 .. len_s]
        for jdx in [1 .. len_t]
            match = null
            if s[idx - 1] is t[j - 1]
                match = 0
            else
                match = 1

            matrix[idx][jdx] = Math.min(Math.min(matrix[idx - 1][jdx] + 1, matrix[idx][jdx - 1] + 1), matrix[idx - 1][jdx - 1] + match)

    matrix[len_s][len_t]


search = ({ bktree, word, delta }) ->



load_func = ->
    blob_1 = fs.readFileSync '../../dictionaries/d1.txt', 'utf8'
    d1 = blob_1.split '\n'

    bktree = { root: null }

    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()
        { bktree } = tree_add_word
            bktree: bktree
            word: word


load_func()
