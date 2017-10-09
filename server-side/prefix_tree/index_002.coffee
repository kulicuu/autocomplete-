



tree_worker = fork(path.resolve(__dirname, 'worker_prefix_tree.coffee'))


sparks = {}

trees = {}



# tree_build_complete = ({}) ->



worker_res_api = {}

worker_res_api.progress_update = ({ payload }) ->
    { perc_count, job_id, client_ref, tree_id } = payload

    if parseInt(perc_count) is 100
        trees[tree_id] = payload.tree

    spark = spark[job_id]
    spark.write
        type: 'progress_update_prefix_tree_build'
        payload: { perc_count, client_ref }








keys_worker_res_api = _.keys worker_res_api


tree_worker.on 'message', ({ type, payload }) ->
    if _.includes(keys_worker_res_api, type)
        worker_res_api[type] { payload }
    else
        c "#{color.yellow('No-Op in prefix_tree_worker_res_api with :', on)} #{color.white(type, on)}"


api = {}


{ get_dctn_raw }  = require('../cache_redis/dctn_002')


api.prefix_tree_build_tree = ({ payload, spark }) ->
    { dctn_name, job_id, client_ref } = payload
    job_id = v4()
    tree_id = v4() # id for the data structure
    sparks[job_id] = spark
    dctn_name = 'd3.txt' #temporarily a mock
    get_dctn_raw { dctn_name }
    .then ({ dctn_blob }) ->
        tree_worker.send
            type: 'build_tree'
            payload:
                job_id : job_id
                dctn_blob: dctn_blob
                client_ref: client_ref
                tree_id: tree_id


api.prefix_tree_search = ({ payload, spark }) ->
    # no need for this to go to a worker.
    { tree_id, prefix, client_ref } = payload





exports.default = api
