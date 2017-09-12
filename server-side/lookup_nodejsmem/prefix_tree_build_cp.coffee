


c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
Bluebird = require 'bluebird'

Redis = require 'redis'
Bluebird.promisifyAll(Redis.RedisClient.prototype)
Bluebird.promisifyAll(Redis.Multi.prototype)
redis = Redis.createClient()


counter = 0


prefix_tree_arq = {}


naive_cache_it = ({ prefix_tree, job_id }) ->
    the_str = JSON.stringify prefix_tree
    redis.hsetAsync 'prefix_tree_naive_cache', job_id, the_str
    .then (re) ->
        c "#{color.green('re on naive_cache_it redis call', on)} #{re}"


break_ties = ({ candides }) ->
    # for now will just return the first,
    # but later can implement the logic for lexicographic order
    candides[0]


map_prefix_to_match = ({ dictionary, prefix }) ->
    candides = []
    for word in dictionary
        if word.indexOf(prefix) is 0
            candides.push word
    if candides.length > 1
        return break_ties { candides }
    else
        return candides.pop()


the_api = {}


the_api['build_it'] = (payload) ->
    { dctn_hash, job_id, spark_ref } = payload
    blob = dctn_hash.as_blob
    raw_rayy = blob.split '\n'
    len_raw_rayy = raw_rayy.length
    perc_count = len_raw_rayy / 100

    tree =
        chd_nodes: {}
        prefix: ''

    for word, idx in raw_rayy
        cursor = tree
        prefix = ''
        unless word.length < 1

            counter++
            perc = counter / perc_count

            if Math.floor(counter % perc_count) is 0
                c 'have a zero'
                process.send
                    type: 'progress_update'
                    payload:
                        perc_count: Math.floor(perc)
                        job_id: job_id
                        spark_ref: spark_ref


            for char, jdx in word
                prefix+= char
                if not _.includes(_.keys(cursor.chd_nodes), char)
                    cursor.chd_nodes[char] =
                        match_word: map_prefix_to_match
                            prefix: prefix
                            dictionary: raw_rayy
                        prefix: prefix
                        chd_nodes: {}
                cursor = cursor.chd_nodes[char]

    naive_cache_it { prefix_tree: tree, job_id: job_id }
    prefix_tree_arq[job_id] = tree

    process.send
        type: 'progress_update'
        payload:
            perc_count: 100
            job_id: job_id


the_api['startup_recover_naive_cache'] = ->
    redis.hgetallAsync 'prefix_tree_naive_cache'
    .then (prefix_tree_arq_str) ->
        c "#{color.green('startup recovering naive cache', on)}"
        # c bktree_arq_str
        _.map prefix_tree_arq_str, (prefix_tree_str, job_id) ->
            prefix_tree_arq[job_id] = JSON.parse prefix_tree_str
    .error (e) ->
        c "#{color.red('there was an error')}"


keys_the_api = _.keys the_api


process.on 'message', ({type, payload }) ->
    if _.includes(keys_the_api, type)
        the_api[type] payload
    else
        c "#{color.yellow('no-op in prefix-tree build-child-process', on)}", "#{color.white(type, on)}"
