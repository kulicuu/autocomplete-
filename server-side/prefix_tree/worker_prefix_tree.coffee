

c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
fp = require 'lodash/fp'
flow = require 'async'

Bluebird = require 'bluebird'

Redis = require 'redis'
Bluebird.promisifyAll(Redis.RedisClient.prototype)
Bluebird.promisifyAll(Redis.Multi.prototype)
redis = Redis.createClient
    port: 6464




send_progress = ({ perc_count, job_id }) ->
    process.send
        type: 'progress_update'
        payload:
            perc_count: perc_count
            job_id: job_id


api = {}


prefix_trees = {}


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


api['build_tree'] = (payload) ->
    counter = 0
    { dctn_blob, job_id, spark_ref } = payload
    raw_rayy = dctn_blob.split '\n'
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
                send_progress
                    perc_count: Math.floor perc
                    job_id: job_id

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

    # naive_cache_it { prefix_tree: tree, job_id: job_id }
    prefix_trees[job_id] = tree
    c "#{color.yellow('should be done now', on)}"

    send_progress
        perc_count: 100
        job_id: job_id


keys_api = _.keys api


process.on 'message', ({ type, payload }) ->
    if _.includes(keys_api, type)
        api[type] payload
    else
        c "#{color.yellow('No-Op in worker_prefix_tree with :', on)} #{color.white(type, on)}"
