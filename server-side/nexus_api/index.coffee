

# So we have this API called Nexus-API,
#  It generalises over the scope of the more specialised APIs BKTree and Prefix-Lookup; also, it should handle the
# Primus stuff, now will need async primus spark handling because of all the redis transactions.
# we want it to load a bunch of dictionaries from a directory on loadup
# then those will be available for



renew_cache = true




startup_routine = ->

    "read_redis_cache"
    " read dictionaries directory"
    " if there are some raw dictionary filenames not seen in the redis library of raw dictionaries, we can add them as well."

    if renew_cache
        initiate_redis_base_hash()
        .then ->
            "read dictionaries into lists"
    else





redis_base_cache_get = (cb) ->
    redis.hgetallAsync 'base_cache_hash'
    .then (re) ->
        cb null, re



redis_base_cache_cons_200 = (cb) ->
    part_264 = (the_hash) ->
        redis.smembersAsync the_hash.dictionaries_raw
        .then (members) ->
            ret_hash = _.assign {},
                base_cache_created: the_hash.base_cache_created
                base_cache_updated: the_hash.base_cache_updated
                dictionaries_raw: []
                data_sets_parsed: []

            c members, 'members'
            control_flow.each members, (member_id, cb) ->
                c member_id, "#{color.cyan('9999', on)}"
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




local_dctns_file_get_dir = (cb) ->
    the_path = path.resolve(__dirname,'..' ,'..', 'dictionaries')
    fs.readdirAsync the_path
    .then (list) ->
        # _.map list, (filename, idx) ->
        cb null, list




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


initiate_redis_base_hash = Bluebird.promisify (cb) ->
    redis.hmsetAsync 'base_cache_hash',
        base_cache_created: Date.now()
        base_cache_updated: Date.now()
        dictionaries_raw: v4()
        data_sets_parsed: v4()
    .then (re) ->
        cb null


add_raw_dictionary = Bluebird.promisify ({filename}, cb) ->
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




setup_and_background_tasks = ->
    c "#{color.green('--------------------------------->', on)}"
    control_flow.parallel [
        redis_base_cache_cons_200
        local_dctns_file_get_dir
    ], (err, results) ->
        [ redis_results, local_dir_results ] = results
        if redis_results is null
            initiate_redis_base_hash()
        else
            red_rs_names = _.reduce redis_results.ret_hash.dictionaries_raw, (acc, v, k) ->
                acc.push v.filename.split('.')[0]
                acc
            , []
            _.map local_dir_results, (filename, idx) ->
                name = filename.split('.')[0]
                if red_rs_names.indexOf(name) is -1
                    add_raw_dictionary { filename }
                    .then ->
                        c "added dictionary raw"
                else
                    c "dctn already added.", name


nexus_api = {}


nexus_api.browse_dctn = ({ type, payload, spark }) ->
    c payload
    redis.hgetAsync 'raw_dctns_lookup_table', payload.filename
    .then (dctn_id) ->
        redis.hgetAsync dctn_id, 'blob'
        .then (re) ->
            c re
            spark.write
                type: 'dctn_initial_blob'
                payload:
                    blob: re


nexus_api.get_raw_dctns_list =  ({ type, payload, spark }) ->
    get_dictionaries_raw()
    .then (ret_rayy) ->
        c ret_rayy
        spark.write
            type: 'ret_raw_dctns_list'
            payload:
                raw_dctns_rayy: ret_rayy



nexus_api = _.assign nexus_api, require('./bktree_spellcheck_api/index.coffee').default

# nexus_api = _.assign nexus_api, require('./prefix_lookup_api/index.coffee').default


keys_nexus_api = _.keys nexus_api

nexus_api_f = ({ type, payload, spark }) ->
    if _.includes(keys_nexus_api, type)
        nexus_api[type] { type, payload, spark }
    else
        c "No-op in nexus_api."



setup_and_background_tasks()








exports.default = nexus_api_f
