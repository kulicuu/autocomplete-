

{ fork } = require 'child_process'

# a misnomer here slightly -- it's not just build, it's search too
bktree_build = fork(path.resolve(__dirname, 'bk-tree-build-cp.coffee'))

# same
prefix_tree_build = fork(path.resolve(__dirname, 'prefix_tree_build_cp.coffee'))


msgr_func = null
# search_responder = null


# node_mem_arq = {}

spark_job_ref = {}

search_job_arq = {}


closure_responder = ({ search_responder, msgr_func, bktree_build }) ->
    bktree_build_res_api = {}

    bktree_build_res_api['res_search_it'] = (payload) ->
        { client_job_id, results, word, delta, search_job_id, spark_ref } = payload
        search_responder { spark_ref, results }

    bktree_build_res_api['progress_update'] = (payload) ->
        { perc_count, job_id } = payload
        { spark_ref, client_job_id } = spark_job_ref[job_id]
        msgr_func { spark_ref, perc_count, client_job_id }

    keys_bktree_build_res_api = _.keys bktree_build_res_api


    bktree_build.on 'message', ({ type, payload }) ->
        c 'parent has msg w type:', type, payload

        if _.includes(keys_bktree_build_res_api, type)
            bktree_build_res_api[type] payload
        else
            c "#{color.yellow('no op in bktree_build_res_api', on)}", "#{color.white(type, off)}"







nodemem_api = {}


nodemem_api['search_struct'] = (payload) ->
    { struct_key, query_expr, spark_ref } = payload
    bktree_build.send
        type: 'search_it'
        payload:
            client_job_id: struct_key
            word: query_expr
            delta: 1
            spark_ref: spark_ref


# bktree build

build_selection_api = {}

build_selection_api['Burkhard-Keller-tree'] = (payload) ->
    { data_struct_type_select, dctn_hash, spark_ref, client_job_id } = payload
    job_id = v4()
    spark_job_ref[job_id] = { spark_ref, data_struct_type_select, client_job_id }
    bktree_build.send
        type: 'build_it'
        payload: _.assign payload,
            job_id: job_id

build_selection_api['prefix-tree'] = (payload) ->
    { data_struct_type_select,
        dctn_hash, spark_ref, client_job_id
    } = payload
    job_id = v4()
    prefix_tree_build.send
        type: 'build_it'
        payload:  _.assign payload,
            job_id: job_id




keys_build_selection_api = _.keys build_selection_api


# nodemem_api['build_selection'] = build_selection_001
nodemem_api['build_selection'] = (payload) ->
    { data_struct_type_select#,
        # dctn_hash, spark_ref, client_job_id
    } = payload

    if _.includes(keys_build_selection_api, data_struct_type_select)
        build_selection_api[data_struct_type_select] payload
    else
        c "#{color.yellow('no-op in build_selection_api with', on)}", "#{color.cyan(data_struct_type_select, on)}"







keys_nodemem_api = _.keys nodemem_api


nodemem_api_fncn = ({ type, payload }) ->
    if _.includes(keys_nodemem_api, type)
        nodemem_api[type] payload
    else
        c "#{color.yellow('no-op in nodemem_apip.', on)}"


exports.default = ({ the_msgr_func, search_responder }) ->

    msgr_func = the_msgr_func
    search_responder = search_responder


    closure_responder
        search_responder: search_responder
        msgr_func: the_msgr_func
        bktree_build: bktree_build

    nodemem_api_fncn


setTimeout ->
    bktree_build.send
        type: 'startup_recover_naive_cache'
, 1000
