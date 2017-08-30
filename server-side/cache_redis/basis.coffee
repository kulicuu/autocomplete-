



# 0. get gr-basis structure; if isn't present build it.
# 1. get filename list from dctn dir hardcoded
# 2. get redis cached dctn list; any filename in dir that isn't in the cache should be imported
# 3. we want the dctn raw to be in multiple forms.  we had initially the pure string blob, now we have also a list, and may add more, r&d style
# 4. we have 2 data types now:   redis-base-hash  or in context of redis
# gr-base-hash  graph-radar, and dctn-base-hash
# 5. won't use classes for this just a factory function.
#



cache_redis_api = {}



gr_basis_factory = ->
    base_cache_created: Date.now()
    base_cache_updated: Date.now()
    # dctns_lists: v4()
    dctns: v4() # could rename to raw_data_srcs
    graphs: v4() # could rename to data_structs
    initialised: 0 # set to 1 when successfully initialised the system


dctn_basis_factory = ({ filename, blob }) ->
    id: v4()
    filename: filename
    date_created: Date.now()
    as_blob: blob
    as_list: v4()


init_gr_basis_000 = Bluebird.promisify (cb) ->
    gr_basis = gr_basis_factory()
    redis.hmsetAsync 'gr_basis_hash',
        gr_basis
    .then (re) ->
        cb null


# this routine / impure function returns a gr-basis-hash-payload
# it builds this first in redis if it's not already built
# this function checks to see if the gr-basis-hash is in redis mem


init_gr_basis_wrap = (cb) ->
    build_payload = (the_hash) ->
        redis.smembersAsync the_hash.dctns
        .then (dctns_ids) ->
            payload = _.assign {},
                base_cache_created: the_hash.base_cache_created
                base_cache_updated: the_hash.base_cache_updated
                dctns: []
                graphs: []
            control_flow.each dctns_ids, (dctn_id, cb2) ->
                redis.hgetallAsync dctn_id
                .then (re) ->
                    payload.dctns.push re
                    cb2 null
            , (err) ->
                cb null, { payload }
    redis.hgetallAsync 'gr_basis_hash'
    .then (the_hash) ->
        if the_hash is null
            init_gr_basis_000()
            .then ->
                redis.hgetallAsync 'gr_basis_hash'
                .then (the_hash) ->
                    build_payload the_hash
        else
            build_payload the_hash


check_local_dctn_dir = (cb) ->
    the_path = path.resolve(__dirname,'..' ,'..', 'dictionaries')
    fs.readdirAsync the_path
    .then (list) ->
        # c list, 'list'
        cb null,
            local_dir_results: list



set_initialised = ->
    redis.hsetAsync 'gr_basis_hash', 'initialised', '1'
    .then ->
        primus.write
            type: 'Initialised.'


exports.default = cache_redis_api



add_raw_dctn = Bluebird.promisify ({ filename }, cb) ->
    redis.hgetAsync 'gr_basis_hash', 'dctns'
    .then (dctns_set_id) ->
        the_path = path.resolve(__dirname, '..', '..', 'dictionaries')
        fs.readFileAsync path.resolve(the_path, filename), 'utf8'
        .then (blob) ->
            word_rayy = blob.split '\n'
            dctn_basis = dctn_basis_factory { filename, blob }
            control_flow.parallel [
                (cb) ->
                    redis.hmsetAsync dctn_basis.id, dctn_basis
                    .then (re) ->
                        cb null
                , (cb) ->
                    redis.lpushAsync dctn_basis.as_list, word_rayy
                    .then (re) ->
                        cb null
                , (cb) ->
                    redis.saddAsync dctns_set_id, dctn_basis.id
                    .then (re) ->
                        cb null
                # , (cb) ->
                #     redis.hsetAsync


            ], (err, results) ->
                cb null

control_flow.parallel [
    init_gr_basis_wrap
    check_local_dctn_dir
], (err, results) ->
    c err, 'err'
    c results, 'results'

    [ gr_basis_res, locals ] = results
    gr_basis = gr_basis_res.payload
    { local_dir_results } = locals

    r_names = _.reduce gr_basis.dctns, (acc, v, k) ->
        acc.push v.filename.split('.')[0]
        acc
    , []
    c r_names

    c local_dir_results, 'local_dir_results'
    _.map local_dir_results, (filename, idx) ->
        name = filename.split('.')[0]
        c name, 'name'
        if r_names.indexOf(name) is -1
            add_raw_dctn { filename }
            .then ->
                c "added dctn raw", filename
        else
            c "already had:", name
