

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
Bluebird = require 'bluebird'

Redis = require 'redis'
Bluebird.promisifyAll(Redis.RedisClient.prototype)
Bluebird.promisifyAll(Redis.Multi.prototype)
redis = Redis.createClient()


bktree_arq = {}


counter = 0


naive_cache_it = ({ bktree, job_id }) ->
    the_str = JSON.stringify bktree
    redis.hsetAsync 'naive_cache' ,job_id, the_str
    .then (re) ->
        c "#{color.green('re on naive_cache_it redis call', on)} #{re}"


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




cursive_search_001 = (node, rayy, word, delta) ->
    cur_delta = lev_d_wrap node.word, word
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
    rtn = cursive_search_001 bktree.root, [], word, 2
    # c rtn, 'rtn'
    rtn


the_api['startup_recover_naive_cache'] = ->
    redis.hgetallAsync 'naive_cache'
    .then (bktree_arq_str) ->
        c "#{color.green('startup recovering naive cache', on)}"
        c bktree_arq_str
        _.map bktree_arq_str, (bktree_str, job_id) ->
            bktree_arq[job_id] = JSON.parse bktree_str
    .error (e) ->
        c "#{color.red('there was an error')}"

the_api['search_it'] = (payload) ->
    c payload, 'payload'
    { client_job_id, word, delta } = payload
    client_job_id = _.keys(bktree_arq)[0]
    c "keys bktree", _.keys(bktree_arq)
    c client_job_id, word, delta
    bktree = bktree_arq[client_job_id]
    results = search { bktree, word, delta }
    process.send
        type: 'res_search_it'
        payload:
            client_job_id: client_job_id
            results: results
            word: word
            delta: delta



the_api['build_it'] = ({ dctn_hash, job_id }) ->
    c "#{color.red(job_id)} #{job_id}"
    blob = dctn_hash.as_blob

    d1 = blob.split '\n'
    len_d1 = d1.length
    counter = 0
    perc_count = len_d1 / 100
    bktree = { root: null }
    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()
    for word, idx in d1
        unless word.length is 0
            counter++
            perc = counter / perc_count
            if Math.floor(counter % perc_count) is 0
                process.send
                    type: 'progress_update'
                    payload:
                        perc_count: Math.floor(perc)
                        job_id: job_id

            { bktree } = tree_add_word
                bktree: bktree
                word: word

    naive_cache_it { bktree, job_id }
    bktree_arq[job_id] = bktree

    process.send
        type: 'progress_update'
        payload:
            perc_count: 100
            job_id: job_id


keys_the_api = _.keys the_api


process.on 'message', ({ type, payload }) ->
    if _.includes(keys_the_api, type)
        c 'bk-tree-build-cp gogo with', type
        the_api[type] payload
    else
        c "#{color.yellow('no op in bk-tree-build-cp', on)}", "#{color.white(type, off)}"
