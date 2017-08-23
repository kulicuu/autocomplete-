


cache_redis_api = {}


initiate_redis_base_hash = Bluebird.promisify (cb) ->
    redis.hmsetAsync 'base_cache_hash',
        base_cache_created: Date.now()
        base_cache_updated: Date.now()
        dictionaries_raw: v4()
        data_sets_parsed: v4()
    .then (re) ->
        cb null


initiate_redis_base_hash()
.then ->
    c 'gogogogoogoo'


get_dictionaries_raw = Bluebird.promisify (cb) ->
    redis.hgetAsync 'base_cache_hash', 'dictionaries_raw'
    .then (set_id) ->
        redis.smembersAsync set_id
        .then (members) ->
            # c members, 'members'
            ret_rayy = []
            control_flow.each members, (member_id, cb2) ->
                redis.hgetallAsync member_id
                .then (member_hash) ->
                    # c member_hash, 'member_hash'
                    ret_rayy.push _.omit(member_hash, ['blob'])
                    cb2 null
            , (err) ->
                c err, 'err'
                cb null, ret_rayy



cache_redis_api['init_redis_cache_base'] = Bluebird.promisify (cb) ->
    initiate_redis_base_hash()
    .then ->
        cb null


cache_redis_api['get_raw_dctns_list'] = Bluebird.promisify ({payload}, cb) ->
    # c 'cb', cb
    get_dictionaries_raw()
    .then (ret_rayy) ->
        cb null,
            payload: { ret_rayy }



cache_redis_api['set_cache_bktree_from_nodejsmem'] = Bluebird.promisify ({ payload }, cb) ->
    { tree_metadata, bktree } = payload



    cb null


cache_redis_api['get_cache_bktree'] = Bluebird.promisify ({ payload }, cb) ->
    { tree_id } = payload


    cb null, { bktree }



keys_cache_redis_api = _.keys cache_redis_api

cache_redis_api_fncn = Bluebird.promisify ({ type, payload }, cb) ->
    if _.includes(keys_cache_redis_api, type)
        cache_redis_api[type] { payload }
        .then ({ payload }) ->
            cb null, { payload }
    else
        c "#{color.yellow('no-op in cache-redis-api.', on)}"


exports.default = cache_redis_api_fncn
