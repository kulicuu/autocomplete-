

sparks = {}
jobs = {}
trees = {}
tree_worker = null # scoped here


worker_res_api = {}


worker_res_api.prefix_tree_blob = ({ payload }) ->
    { job_id, string_tree, tree_id } = payload
    spark = sparks[job_id]
    spark.write
        type: 'res_radar_graph'
        payload:
            tree_id: tree_id
            string_tree: string_tree


worker_res_api.match_report = ({ payload }) ->
    { match_set, job_id } = payload
    spark = sparks[job_id]
    spark.write
        type: 'prefix_tree_match_report'
        payload: { match_set }


worker_res_api.progress_update = ({ payload }) ->
    { perc_count, job_id, tree_id } = payload
    if parseInt(perc_count) is 100
        trees[tree_id] = payload.tree
    client_ref = jobs[job_id].client_ref
    spark = sparks[job_id]
    spark.write
        type: 'progress_update_prefix_tree_build'
        payload: { perc_count, client_ref, tree_id }


keys_worker_res_api = _.keys worker_res_api


start_drone = ->
    tree_worker = fork(path.resolve(__dirname, 'worker_prefix_tree.coffee'))
    tree_worker.on 'message', ({ type, payload }) ->
        if _.includes(keys_worker_res_api, type)
            worker_res_api[type] { payload }
        else
            c "#{color.yellow('No-Op in prefix_tree_worker_res_api with :', on)} #{color.white(type, on)}"


api = {}


{ get_dctn_raw }  = require('../cache_redis/dctn_002')


api.radar_graph = ({ payload, spark }) ->
    { tree_id } = payload
    job_id = v4()
    sparks[job_id] = spark
    tree_worker.send
        type: 'get_tree'
        payload: { tree_id, job_id }


api.search_prefix_tree = ({ payload, spark }) ->
    job_id = v4()
    sparks[job_id] = spark
    tree_worker.send
        type: 'search_prefix_tree'
        payload: fp.assign payload, { job_id }


api.cancel_prefix_tree_job = ({ payload, spark }) ->
    # TODO : specifics on particular job, and also spark cleanup.
    # tree_worker.send
    #     type: 'cancel_build_job'
    #     payload: null # but will cleanup later, and also should get acks, TODO
    tree_worker.kill()
    setTimeout ->
        start_drone()
    , 100


api.prefix_tree_build_tree = ({ payload, spark }) ->
    { dctn_name, job_id, client_ref } = payload
    job_id = v4()
    tree_id = v4() # id for the data structure
    sparks[job_id] = spark
    jobs[job_id] =
        client_ref: client_ref
    get_dctn_raw { dctn_name }
    .then ({ dctn_blob }) ->
        tree_worker.send
            type: 'build_tree'
            payload:
                job_id : job_id
                dctn_blob: dctn_blob
                client_ref: client_ref # may be superfluous
                tree_id: tree_id


exports.default = api


setTimeout ->
    start_drone()
, 100
