
# TODO : and Doing:  Clean up and refactor this implementation, in index_002.coffee


cache_redis_api = require('../cache_redis/index').default


progress_update_msgr = ({ spark_ref, perc_count }) ->
    { spark, client_job_id } = spark_icebox[spark_ref]
    spark.write
        type: 'build_progress_update'
        payload:
            perc_count: perc_count
            client_job_id: client_job_id


search_responder = ({ spark_ref, results }) ->
    { spark } = spark_icebox[spark_ref]
    spark.write
        type: 'res_search_struct_nodemem'
        payload:
            search_results: results


nodemem_api = require('../lookup_nodejsmem/index').default
    the_msgr_func: progress_update_msgr
    search_responder: search_responder


brujo_api = {}


redis_lua_api = require('../lookup_redis/index.coffee').default
brujo_api = _.assign brujo_api, redis_lua_api


spark_icebox = {}


brujo_api['search_struct_nodemem'] = ({ type, payload, spark }) ->
    spark_ref = v4()
    spark_icebox[spark_ref] =
        spark: spark

    nodemem_api
        type: 'search_struct'
        payload: _.assign payload, { spark_ref }


brujo_api['build_selection'] = ({ type, payload, spark }) ->
    { data_src_select, data_struct_type_select, client_job_id } = payload
    cache_redis_api
        type: 'get_raw_dctn'
        payload: { data_src_select }
    .then ({ payload }) -> # contains arq plus some meta info
        { dctn_hash } = payload
        spark_ref = v4()
        spark_icebox[spark_ref] =
            spark: spark
            client_job_id: client_job_id
            # data_src_select: data_src_select
            # data_struct_type_select: data_struct_type_select
        nodemem_api
            type: 'build_selection'
            payload: { dctn_hash, data_struct_type_select, spark_ref, progress_update_msgr }


brujo_api['browse_dctn'] = ({ type, payload, spark }) ->
    cache_redis_api
        type: type
        payload: payload
    .then ({ payload }) ->
        spark.write
            type: 'res_browse_raw_dctn'
            payload: payload


brujo_api['get_initial_stati'] = ({ type, spark }) ->
    # get also built and cached data structures
    # and also maybe those in memory.
    cache_redis_api { type }
    .then ({ payload }) ->
        spark.write
            type: 'res_get_initial_stati'
            payload: payload


brujo_api["get_raw_dctns_list"] = ({ type, spark }) ->
    cache_redis_api { type }
    .then ({ payload }) ->
        spark.write
            type: 'res_get_raw_dctns_list'
            payload: payload.payload


brujo_api["get_algos_list"] = ({ spark }) ->
    spark.write
        type: 'res_get_algos_list'
        payload: [ 'burkhard-keller_tree', 'prefix_tree']


brujo_api["build_data_struct_into_nodejs_mem"] = ({
    data_structure_type, dctn_name }) ->


brujo_api["build_data_struct_into_redis_mem"] = ({
     data_structure_instance_id, dctn_name, instance_name
}) ->


brujo_api["search_data_structure_in_redis"] = Bluebird.promisify ({
    data_structure_type, search_data
}, cb) ->


brujo_api["search_data_structure_in_nodejsmem"] = ({
    payload, spark
}) ->
    {
        data_structure_instance_id
        search_data
    } = payload


keys_brujo_api = _.keys brujo_api


brujo_api_fncn = ({ type, payload, spark }) ->
    if _.includes(keys_brujo_api, type)
        brujo_api[type] { type, payload, spark }
    else
        c "#{color.yellow('no op in brujo layer controller:', on)}", "#{color.cyan(type, on)}"


exports.default = brujo_api_fncn
