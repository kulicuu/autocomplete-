



# NOTE:  To construct a BKtree like
# https://nullwords.wordpress.com/2013/03/13/the-bk-tree-a-data-structure-for-spell-checking/
# for spell check.  also define the seaorch function here.




lev_d = require('./levenshtein_distance.coffee').default


load_func = ->

    blob_1 = fs.readFileSync '../dictionaries/d1.txt', 'utf8'
    d1 = blob_1.split '\n'
    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()




node_f = ({ word }) ->
    word: word
    chd_nodes: {}





contains_key = ({ node, key }) ->
    if _.includes(_.keys(node.chd_nodes), key)
        return true
    else
        return false



add_chd = ({ node, key, word }) ->
    # if _.keys(node.chd_nodes).length is 0
    node.chd_nodes[key] = node_f { word }





add_node = ({ bktree, word }) ->
    if bktree.root is null
        bktree.root = node_f({ word })
        return { bktree }

    cur_node = bktree.root

    delta = lev_d cur_node.word, word
    while _.includes(_.keys(cur_node), delta)
        if delta is 0 then return { bktree }

        cur_node = cur_node[delta]
        delta = lev_d cur_node.word, word

    cur_node.





recursive_search = ({ rayy, node, str, rayy_rtn, word, delta }) ->
    cur_del = lev_d node.word, word
    min_del = cur_del - delta
    max_del = cur_del + delta

    if cur_del is delta
        add_node
            bktree:



search_bktree = ({ bktree, word, delta }) ->
