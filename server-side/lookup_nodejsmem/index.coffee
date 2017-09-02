

{ fork } = require 'child_process'

bktree_build = fork(path.resolve(__dirname, 'bk-tree-build-cp.coffee'))


msgr_func = null


node_mem_arq = {}

spark_job_ref = {}


bktree_build_res_api = {}

# we need to register a callback by id to the spark we need to reference
# otherwise won't know where to send the updates.


bktree_build_res_api['test3'] = ({ payload }) ->
    c 'payload', payload


bktree_build_res_api['progress_update'] = ({ payload }) ->
    c 'progr'
    { perc_count, job_id } = payload
    { spark_ref, client_job_id } = spark_job_ref[job_id]
    c spark_ref, 'spark_ref'
    msgr_func { spark_ref, perc_count, client_job_id }
    # spark.write
    #     type: 'golan giladi'


bktree_build_res_api['res_build_it'] = ({ payload }) ->
    c "#{color.blue('in res_build_it', on)}"
    c payload, 'payload'
    { job_id, built_struct } = payload
    { cb, spark_ref } = spark_job_ref[job_id]
    node_mem_arq['bktree_struct'] = payload.built_struct
    cb null, { built_struct, spark_ref }





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



# TODO :
# 0. Implement this into another thread childprocess
# 1. signals to abort, results saved refs in some data structure
#


nodemem_api['search_struct'] = Bluebird.promisify ({ payload }, cb) ->
    { struct_key, query_expr } = payload
    bktree = node_mem_arq[_.keys(node_mem_arq)[0]]
    rtn = bktree_search
        bktree: bktree
        word: query_expr
        delta: null
    cb null,
        payload:
            search_results: rtn



build_selection_001 = Bluebird.promisify ({ type, payload}, cb) ->
    { data_struct_type_select, dctn_hash, spark_ref, client_job_id } = payload
    # msgr_func = progress_update_msgr
    job_id = v4()
    spark_job_ref[job_id] = { cb, spark_ref, data_struct_type_select, client_job_id }
    c payload, 'payload \n'
    bktree_build.send
        type: 'build_it'
        payload: _.assign payload,
            job_id: job_id



nodemem_api['build_selection'] = build_selection_001

# nodemem_api['build_selection'] = Bluebird.promisify ({ type, payload }, cb) ->
    # { data_struct_type_select, dctn_hash } = payload
    # if _.includes(keys_build_selection, data_struct_type_select)
    #     build_selection[data_struct_type_select] { blob: dctn_hash.as_blob }
    #     .then ({ payload }) ->
    #         node_mem_arq[data_struct_type_select] = payload.built_struct
    #         cb null, { payload }




keys_nodemem_api = _.keys nodemem_api


nodemem_api_fncn = Bluebird.promisify ({ type, payload }, cb) ->
    if _.includes(keys_nodemem_api, type)
        nodemem_api[type] { payload }
        .then ({ payload }) -> # is this a code smell ?  two payloads one overwriting the other ?
        # i think it is but it would be worse to have awkward names for the response, ...
            c '88888888'
            cb null, payload
    else
        c "#{color.yellow('no-op in nodemem_apip.', on)}"






exports.default = ({ the_msgr_func }) ->
    msgr_func = the_msgr_func
    nodemem_api_fncn
