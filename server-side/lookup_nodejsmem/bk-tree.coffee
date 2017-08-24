
counter = 0


add_chd_to_node = ({ node, key, word }) ->
    node.chd_nodes[key] = node_f { word }

# recursive version
lev_d = ( s, len_s, t, len_t ) ->
    # if counter++ < 10
    cost = null

    if len_s is 0 then return len_t
    if len_t is 0 then return len_s

    if s[len_s - 1] is t[len_t - 1]
        cost = 0
    else
        cost = 1

    Math.min (lev_d( s, len_s - 1, t, len_t ) + 1),
    (lev_d( s, len_s, t, len_t - 1) + 1),
    (lev_d(s, len_s - 1, t, len_t - 1) + cost)



lev_d_wrap = ( s, t ) ->
    len_s = s.length
    len_t = t.length
    lev_d s, len_s, t, len_t



# node
node_f = ({ word }) ->
    word: word
    chd_nodes: {}






tree_add_word = ({ bktree, word }) ->
    if bktree.root is null
        bktree.root = node_f({ word })
        return { bktree }
    cur_node = bktree.root

    delta = lev_d_wrap cur_node.word, word
    while _.includes(_.keys(cur_node.chd_nodes), '' + delta)
        if delta is 0
            return { bktree }
        cur_node = cur_node.chd_nodes[delta]
        delta = lev_d_wrap cur_node.word, word
    add_chd_to_node
        node: cur_node
        key: delta
        word: word
    { bktree }





build_it = Bluebird.promisify ({ blob }, cb) ->

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



exports.default = build_it
