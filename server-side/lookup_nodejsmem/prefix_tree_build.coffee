


c = console.log.bind console
color = require 'bash-color'
_ = require 'lodash'
Bluebird = require 'bluebird'

Redis = require 'redis'
Bluebird.promisifyAll(Redis.RedisClient.prototype)
Bluebird.promisifyAll(Redis.Multi.prototype)
redis = Redis.createClient()



prefix_tree_arq = {}


naive_cache_it = ({ prefix_tree, job_id }) ->
    the_str = JSON.stringify prefix_tree
    redis.hsetAsync 'naive_cache' ,job_id, the_str
    .then (re) ->
        c "#{color.green('re on naive_cache_it redis call', on)} #{re}"



map_prefix_to_match = ({ dictionary, prefix }) ->
    candides = []
    for word in dictionary
        if word.indexOf(prefix) is 0
            candides.push word
    if candides.length > 1
        return break_ties { candides }
    else
        return candides.pop()



loader_fncn = ({ raw_dctn }) ->

    raw_rayy = raw_dctn.split '\n'
    rayy_rayy = _.map raw_rayy, (word, idx) ->
        word.toLowerCase()

    tree =
        chd_nodes: {}
        prefix: ''

    for word, idx in raw_rayy
        c "#{color.green('building word: ', on)}", "#{color.cyan(word, on)}"
        cursor = tree
        prefix = ''
        unless word.length < 1
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
