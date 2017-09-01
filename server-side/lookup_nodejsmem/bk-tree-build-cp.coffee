



c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
Bluebird = require 'bluebird'





counter = 0


add_chd_to_node = ({ node, key, word }) ->
    node.chd_nodes[key] = node_f { word }

# recursive version
lev_d = ( s, len_s, t, len_t ) ->
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
    cb null,
        payload:
            built_struct: bktree




the_api = {}


the_api['test2'] = ->
    c 'satheaustha'
    process.send
        type: 'test3'
        payload:
            nothing: 'yet'


the_api['build_it'] = ({ dctn_hash, job_id }) ->
    blob = dctn_hash.as_blob
    d1 = blob.split '\n'
    bktree = { root: null }
    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()
    for word, idx in d1
        unless word.length is 0
            c 'word', word
            { bktree } = tree_add_word
                bktree: bktree
                word: word
    process.send
        type: 'res_build_it'
        payload:
            built_struct: bktree
            job_id: job_id


keys_the_api = _.keys the_api


process.on 'message', ({ type, payload }) ->
    if _.includes(keys_the_api, type)
        c 'bk-tree-build-cp gogo with', type
        the_api[type] payload
    else
        c "#{color.yellow('no op in bk-tree-build-cp', on)}", "#{color.white(type, off)}"
