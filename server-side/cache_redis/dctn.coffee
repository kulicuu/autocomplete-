




cache_redis_api = {}



cache_redis_api.get_dctns_hashes = Bluebird.promisify (cb) ->


dctn_lookup_id_by_name = Bluebird.promisify ({ dctn_name }, cb) ->
    redis.hgetAsync 'dctns_id_lookup_by_name', dctn_name
    .then (dctn_id) ->
        cb null, { dctn_id }


# browse the list structure
cache_redis_api['browse_raw_dctn'] = Bluebird.promisify ({ type, payload }, cb) ->
    { upper_bound, lower_bound, dctn_name } = payload
    dctn_lookup_id_by_name { dctn_name }
    .then ({ dctn_id }) ->
        redis.hgetAsync dctn_id, 'as_list'
        .then ( list_id ) ->
            redis.lrangeAsync list_id, lower_bound, upper_bound
            .then ( the_rayy ) ->
                cd null, { browse_rayy }



cache_redis_api['get_raw_dctns_list'] = Bluebird.promisify ({payload}, cb) ->
    ret_arq = []
    redis.hgetAsync 'gr_basis_hash', 'dctns'
    .then (dctns_set_id) ->
        redis.smembersAsync dctns_set_id
        .then (dctns_hashes_rayy) ->
            control_flow.each dctns_hashes_rayy, (dctn_hash_id, cb2) ->
                redis.hgetallAsync dctn_hash_id
                .then (dctn_hash) ->
                    ret_arq.push _.omit(dctn_hash, ['id', 'as_list', 'as_blob'])
                    cb2 null
            , (err) ->
                cb null,
                    payload: ret_arq



exports.default = cache_redis_api
