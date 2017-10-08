

dctn_lookup_id_by_name = Bluebird.promisify ({ dctn_name }, cb) ->
    c dctn_name, 'dctn_name'
    redis.hgetAsync 'dctns_id_lookup_by_name', dctn_name
    .then (dctn_id) ->
        cb null, { dctn_id }


api = {}


api.get_raw_dctns_list = ({ payload, spark }) ->
    ret_arq = []
    redis.hgetAsync 'gr_basis_hash', 'dctns'
    .then (dctns_set_id) ->
        redis.smembersAsync dctns_set_id
        .then (dctns_hashes_rayy) ->
            flow.each dctns_hashes_rayy, (dctn_hash_id, cb2) ->
                redis.hgetallAsync dctn_hash_id
                .then (dctn_hash) ->
                    ret_arq.push _.omit(dctn_hash, ['id', 'as_list', 'as_blob'])
                    cb2 null
            , (err) ->
                spark.write
                    type: 'res_get_raw_dctns_list'
                    payload: ret_arq


api.browse_dctn = ({ payload, spark }) ->
    { upper_bound, lower_bound, dctn_name } = payload
    dctn_lookup_id_by_name { dctn_name }
    .then ({ dctn_id }) ->
        redis.hgetAsync dctn_id, 'as_list'
        .then ( list_id ) ->
            redis.lrangeAsync list_id, lower_bound, upper_bound
            .then ( browse_rayy ) ->
                spark.write
                    type: 'res_browse_raw_dctn'
                    payload: { browse_rayy }



exports.default = api
