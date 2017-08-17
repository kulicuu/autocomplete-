

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



read_redis_cache = ->





read_dir = ->


redis_base_cache_get = (cb) ->
    redis.hgetallAsync 'base_cache_hash'
    .then (re) ->
        c re, 're'
        cb null, re




part_464 =


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
        c the_hash, 'the_hash'


        if the_hash is null
            c 'is null'
            initiate_redis_base_hash()
            .then ->
                redis.hgetallAsync 'base_cache_hash'
                .then (the_hash) ->
                    part_264 the_hash
                    # redis.smembersAsync the_hash.dictionaries_raw
                    # .then (members) ->
                    #     ret_hash = _.assign {},
                    #         base_cache_created: the_hash.base_cache_created
                    #         base_cache_updated: the_hash.base_cache_updated
                    #         dictionaries_raw: []
                    #         data_sets_parsed: []
                    #
                    #     c members, 'members'
                    #     control_flow.each members, (member_id, cb) ->
                    #         c member_id, "#{color.cyan('9999', on)}"
                    #         redis.hgetallAsync member_id
                    #         .then (re) ->
                    #             c _.keys(re)
                    #             ret_hash.dictionaries_raw.push re # later will be more involved to get the hash out of redis
                    #             cb null
                    #
                    #     , (err) ->
                    #         c "#{color.yellow('.9383838', on)}", err
                    #         cb null, { ret_hash }



        else
        # assuming no errors
            part_264 the_hash
            # redis.smembersAsync the_hash.dictionaries_raw
            # .then (members) ->
            #     ret_hash = _.assign {},
            #         base_cache_created: the_hash.base_cache_created
            #         base_cache_updated: the_hash.base_cache_updated
            #         dictionaries_raw: []
            #         data_sets_parsed: []
            #
            #     c members, 'members'
            #     control_flow.each members, (member_id, cb) ->
            #         c member_id, "#{color.cyan('9999', on)}"
            #         redis.hgetallAsync member_id
            #         .then (re) ->
            #             c _.keys(re)
            #             ret_hash.dictionaries_raw.push re # later will be more involved to get the hash out of redis
            #             cb null
            #
            #     , (err) ->
            #         c "#{color.yellow('.9383838', on)}", err
            #         cb null, { ret_hash }




local_dctns_file_get_dir = (cb) ->
    the_path = path.resolve(__dirname,'..' ,'..', 'dictionaries')
    fs.readdirAsync the_path
    .then (list) ->
        _.map list, (filename, idx) ->
            # c filename
        cb null, list




get_dictionaries_raw = Bluebird.promisify (cb) ->
    redis.hgetAsync 'base_cache_hash', 'dictionaries_raw'
    .then (set_id) ->
        redis.smembersAsync set_id
        .then (members) ->
            c members, 'members'
            cb null, members


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
        c dctn_bskt_id
        the_path = path.resolve(__dirname,'..' ,'..', 'dictionaries')
        fs.readFileAsync path.resolve(the_path, filename), 'utf8'
        .then (blob) ->
            c blob.length, 'blob'
            dctn_id = v4()
            control_flow.parallel [
                (cb) ->
                    redis.hmsetAsync dctn_id,
                        filename: filename
                        date_created: Date.now()
                        blob: blob
                    .then (re) ->
                        c re, 're'
                        cb null

                ,(cb) ->
                    redis.saddAsync(dctn_bskt_id, dctn_id)
                    .then (re) ->
                        cb null
            ], (err, results) ->
                # c 'err', err
                # c results

            # redis
                cb null




setup_and_background_tasks = ->
    c "#{color.green('--------------------------------->', on)}"
    control_flow.parallel [
        redis_base_cache_cons_200
        local_dctns_file_get_dir
    ], (err, results) ->
        c err, 'err'
        c results, 'results'

        [ redis_results, local_dir_results ] = results


        if redis_results is null

            initiate_redis_base_hash()
            # .then ->
            #     get_dictionaries_raw()
        else
            c '\n\n', "#{color.green('----------------eeeeeeeeeeee')}"
            c redis_results
            c local_dir_results, '88383838'

            red_rs_names = redis_results.ret_hash.dictionaries_raw
            c redis_results, 'redis_results'
            # red_rs_names = _.reduce redis_results,
            _.map local_dir_results, (filename, idx) ->
                name = filename.split('.')[0]
                c red_rs_names, 'red_rs_names'
                if red_rs_names.indexOf(name) is -1
                    add_raw_dictionary { filename }
                    .then ->
                        c '99eeeeeeeeeeeeee999'
                else
                    c '1010101'


            # initiate_redis_base_hash()
            # .then ->
            # get_dictionaries_raw()
            # .then (re) ->
            #     c re, 're888'





    # c __dirname, '__dirname'
    # the_path = path.resolve(__dirname,'..' ,'..', 'dictionaries')
    # fs.readdirAsync the_path
    # .then (list) ->
    #     _.map list, (filename, idx) ->
    #         c filename
    #         # c idx
    # .error (e) ->
    #     c e
    # we are using redis as a memory that persists over nodemon restarts
    # check what redis memory is already there
    # load the dictionaries into memory



nexus_api = {}




nexus_api.get_raw_dctns_list =  ({ type, payload, spark }) ->
    c "#{color.green('333.', on)}"
    get_dictionaries_raw()
    .then (hello) ->
        c hello.length



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
