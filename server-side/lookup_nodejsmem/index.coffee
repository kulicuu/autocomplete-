

{ fork } = require 'child_process'

bktree_build = fork(path.resolve(__dirname, 'bk-tree-build-cp.coffee'))


msgr_func = null


# node_mem_arq = {}

spark_job_ref = {}

search_job_arq = {}


bktree_build_res_api = {}

# we need to register a callback by id to the spark we need to reference
# otherwise won't know where to send the updates.



bktree_build_res_api['res_search_it'] = ({ payload }) ->




bktree_build_res_api['progress_update'] = ({ payload }) ->
    { perc_count, job_id } = payload
    { spark_ref, client_job_id } = spark_job_ref[job_id]
    msgr_func { spark_ref, perc_count, client_job_id }







keys_bktree_build_res_api = _.keys bktree_build_res_api



bktree_build.on 'message', ({ type, payload }) ->
    c 'parent has msg w type:', type

    if _.includes(keys_bktree_build_res_api, type)
        bktree_build_res_api[type] { payload }
    else
        c "#{color.yellow('no op in bktree_build_res_api', on)}", "#{color.white(type, off)}"





bktree_build.send
    type: 'test2'
    payload:
        wacka: "walla"





build_selection = {}


build_selection['BK-tree'] = require('./bk-tree.coffee').default

bktree_search = require('./bk-tree.coffee').search

build_selection['prefix-tree'] = Bluebird.promisify ({ payload }, cb) ->
    c '222'

keys_build_selection = _.keys build_selection


nodemem_api = {}








nodemem_api['search_struct'] = ({ payload }) ->
    { struct_key, query_expr, spark_ref } = payload
    search_job_id = v4()
    search_job_arq[search_job_id] = { spark_ref }

    bktree_build.send
        type: 'search_it'
        payload:
            client_job_id: struct_key
            word: query_expr
            delta: 1






build_selection_001 = ({ type, payload }) ->
    { data_struct_type_select, dctn_hash, spark_ref, client_job_id } = payload
    job_id = v4()
    spark_job_ref[job_id] = { spark_ref, data_struct_type_select, client_job_id }
    c payload, 'payload \n'
    bktree_build.send
        type: 'build_it'
        payload: _.assign payload,
            job_id: job_id



nodemem_api['build_selection'] = build_selection_001



keys_nodemem_api = _.keys nodemem_api


nodemem_api_fncn = ({ type, payload }) ->
    if _.includes(keys_nodemem_api, type)
        nodemem_api[type] { type, payload }
    else
        c "#{color.yellow('no-op in nodemem_apip.', on)}"


exports.default = ({ the_msgr_func }) ->
    msgr_func = the_msgr_func
    nodemem_api_fncn
