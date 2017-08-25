


cache_redis_api = {}


initiate_redis_base_hash = Bluebird.promisify (cb) ->
    redis.hmsetAsync 'base_cache_hash',
        base_cache_created: Date.now()
        base_cache_updated: Date.now()
        dictionaries_raw: v4() # could rename to raw_data_srcs
        data_sets_parsed: v4() # could rename to data_structs
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
            ret_rayy = []
            control_flow.each members, (member_id, cb2) ->
                redis.hgetallAsync member_id
                .then (member_hash) ->
                    ret_rayy.push _.omit(member_hash, ['blob'])
                    cb2 null
            , (err) ->
                c err, 'err'
                cb null, ret_rayy



# cache_redis_api['init_redis_cache_base'] = Bluebird.promisify (cb) ->
#     initiate_redis_base_hash()
#     .then ->
#         cb null




cache_redis_api['browse_raw_dctn'] = ({ type, payload }) ->
    { upper_bound, lower_bound, dctn_name } = payload
    # NOTE this indicates should use a different data structure for caching.  probably a list.
    redis.hgetAsync 'raw_dctns_list_lu_table', dctn_name
    .then (dctn_list_id) ->
        redis.lrange dctn_list_id, lower_bound, upper_bound


cache_redis_api



cache_redis_api['get_raw_dctn'] = Bluebird.promisify ({ payload }, cb) ->

cache_redis_api['get_raw_dctn'] = Bluebird.promisify ({ payload }, cb) ->
    { data_src_select } = payload
    redis.hgetAsync 'raw_dctns_lookup_table', data_src_select
    .then (dctn_id) ->
        redis.hgetallAsync dctn_id
        .then (dctn_hash) ->
            cb null, { payload: { dctn_hash } }



cache_redis_api['get_initial_stati'] = Bluebird.promisify ({ payload }, cb) ->
    c "#{color.cyan('!has', on)}"

    # all the dictionaries minus the blobs
    # all the data structs

    cb null, { payload: null }


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




redis_base_cache_cons_200 = (cb) ->
    part_264 = (the_hash) ->
        redis.smembersAsync the_hash.dictionaries_raw
        .then (members) ->
            ret_hash = _.assign {},
                base_cache_created: the_hash.base_cache_created
                base_cache_updated: the_hash.base_cache_updated
                dictionaries_raw: []
                data_sets_parsed: []

            # c members, 'members'
            control_flow.each members, (member_id, cb) ->
                # c member_id, "#{color.cyan('9999', on)}"
                redis.hgetallAsync member_id
                .then (re) ->
                    c _.keys(re)
                    ret_hash.dictionaries_raw.push re # later will be more involved to get the hash out of redis
                    cb null

            , (err) ->
                c "#{color.yellow('.9383838', on)}", err
                cb null, { ret_hash }


    redis.hgetallAsync 'base_cache_hash'
    .then (the_hash) ->
        # c the_hash, 'the_hash'
        if the_hash is null
            # c 'is null'
            initiate_redis_base_hash()
            .then ->
                redis.hgetallAsync 'base_cache_hash'
                .then (the_hash) ->
                    part_264 the_hash
        else
            # assuming no errors
            part_264 the_hash






add_raw_dctn_103 = Bluebird.promisify ({ filename }, cb) ->
    redis.hgetAsync 'base_cache_hash', 'dictionaries_raw'
    .then (dctn_bskt_id) ->
        the_path = path.resolve(__dirname, '..', '..', 'dictionaries')
        fs.readFileAsync path.resolve(the_path, filename), 'utf8'
        .then (blob) ->
            word_rayy = blob.split '\n'
            dctn_hash_id = v4()
            dctn_list_id = v4()

            control_flow.parallel [
                (cb) ->
                    redis.hmsetAsync dctn_hash_id,
                        filename: filename
                        date_created: Date.now()
                        blob: dctn_list_id
                    .then (re) ->
                        cb null
                ,(cb) ->
                    redis.lpushAsync dctn_list_id, word_rayy
                    .then (re) ->
                        cb null
                ,(cb) ->
                    redis.hsetAsync 'raw_dctns_list_lu_table', filename, dctn_list_id
                    .then (re) ->
                        cb null
                ,(cb) ->
                    redis.hsetAsync 'raw_dctns_hash_lu_tbl', filename, dctn_list_id
            ], (err, results) ->
                cb null


add_raw_dictionary = Bluebird.promisify ({ filename }, cb) ->
    redis.hgetAsync 'base_cache_hash', 'dictionaries_raw'
    .then (dctn_bskt_id) ->
        the_path = path.resolve(__dirname,'..' ,'..', 'dictionaries')
        fs.readFileAsync path.resolve(the_path, filename), 'utf8'
        .then (blob) ->
            dctn_id = v4()
            control_flow.parallel [
                (cb) ->
                    redis.hsetAsync 'raw_dctns_lookup_table', filename, dctn_id
                    .then (re) ->
                        c "adding filename and id to lookup table: #{re}"
                    redis.hmsetAsync dctn_id,
                        filename: filename
                        date_created: Date.now()
                        blob: blob
                    .then (re) ->
                        cb null
                ,(cb) ->
                    redis.saddAsync(dctn_bskt_id, dctn_id)
                    .then (re) ->
                        cb null
            ], (err, results) ->
                cb null



local_dctns_file_get_dir = (cb) ->
    the_path = path.resolve(__dirname,'..' ,'..', 'dictionaries')
    fs.readdirAsync the_path
    .then (list) ->
        # _.map list, (filename, idx) ->
        cb null, list


setup_and_background_tasks = ->
    c "#{color.green('--------------------------------->', on)}"
    control_flow.parallel [
        redis_base_cache_cons_200
        local_dctns_file_get_dir
    ], (err, results) ->
        [ redis_results, local_dir_results ] = results
        if redis_results is null
            initiate_redis_base_hash()
            .then ->
                setup_and_background_tasks()
        else
            red_rs_names = _.reduce redis_results.ret_hash.dictionaries_raw, (acc, v, k) ->
                acc.push v.filename.split('.')[0]
                acc
            , []
            _.map local_dir_results, (filename, idx) ->
                name = filename.split('.')[0]
                if red_rs_names.indexOf(name) is -1
                    add_raw_dctn_103 { filename }
                    .then ->
                        c "added dictionary raw"
                else
                    c "dctn already added.", name



setup_and_background_tasks()
