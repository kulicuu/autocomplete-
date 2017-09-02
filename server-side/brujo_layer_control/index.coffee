# NOTE there will be a ton of functions here which will find broadly some grouping.
# this is basically a Controller function.



# { redis_caching_api, redis_lookup_api } = require('../redis_layer/index')
# this may well contain


cache_redis_api = require('../cache_redis/index').default


progress_update_msgr = ({ spark_ref, perc_count }) ->
    c spark_ref, 'spark_ref'
    c spark_icebox[spark_ref]
    { spark } = spark_icebox[spark_ref]

    spark.write
        type: 'build_progress_update'
        payload:
            perc_count: perc_count
            # data_src_select: data_src_select
            # data_struct_type_select: data_struct_type_select


nodemem_api = require('../lookup_nodejsmem/index').default
    the_msgr_func: progress_update_msgr


brujo_api = {}

spark_icebox = {}







brujo_api['search_struct_nodemem'] = ({ type, payload, spark }) ->
    nodemem_api
        type: 'search_struct'
        payload: payload
    .then ({ search_results }) ->
        spark.write
            type: 'res_search_struct_nodemem'
            payload:
                search_results: search_results



brujo_api['build_selection'] = ({ type, payload, spark }) ->
    { data_src_select, data_struct_type_select } = payload
    cache_redis_api
        type: 'get_raw_dctn'
        payload: { data_src_select }
    .then ({ payload }) -> # contains arq plus some meta info
        { dctn_hash } = payload
        spark_ref = v4()
        c "#{color.green('spark', on)}"
        c spark
        spark_icebox[spark_ref] =
            spark: spark
            # data_src_select: data_src_select
            # data_struct_type_select: data_struct_type_select
        nodemem_api
            type: 'build_selection'
            payload: { dctn_hash, data_struct_type_select, spark_ref, progress_update_msgr }
        .then ( payload ) ->
            cache_redis_api
                type: 'cache_data_struct'
                payload:
                    data_struct_type_select: data_struct_type_select
            spark.write
                type: 'res_build_selection'
                payload: payload




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
        c payload, '494949494'
        # { ret_rayy } = payload
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
