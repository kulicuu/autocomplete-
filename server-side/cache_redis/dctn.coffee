




cache_redis_api = {}



cache_redis_api.get_dctns_hashes = Bluebird.promisify (cb) ->



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
                c 'ererrerere', err
                c ret_arq
                cb null,
                    payload: ret_arq






exports.default = cache_redis_api
