# NOTE there will be a ton of functions here which will find broadly some grouping.
# this is basically a Controller function.



# { redis_caching_api, redis_lookup_api } = require('../redis_layer/index')
# this may well contain


cache_redis_api = require('../cache_redis/index').default

nodemem_api = require('../lookup_nodejsmem/index').default


brujo_api = {}



brujo_api['build_selection'] = ({ type, payload, spark }) ->
    { data_src_select, data_struct_type_select } = payload
    cache_redis_api
        type: 'get_raw_dctn'
        payload: { data_src_select }
    .then ({ payload }) -> # contains arq plus some meta info
        { dctn_hash } = payload
        c '883838'
        nodemem_api
            type: 'build_selection'
            payload: { dctn_hash, data_struct_type_select }
        .then ({ payload }) ->
            spark.write
                type: 'res_build_selection'
                payload: payload


brujo_api['get_initial_stati'] = ({ type, spark }) ->
    # get also built and cached data structures
    # and also maybe those in m
        #     type: 'build_selection'
        #     payload: { raw_dctn_arq, data_struct_type_select }
        # .then ({ payload }) ->
        #     spark.write
        #         type: 'res_build_selection'
        #         payload: payload


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
        { ret_rayy } = payload
        spark.write
            type: 'res_get_raw_dctns_list'
            payload: ret_rayy


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
        c "No-op in nexus_api."














exports.default = brujo_api_fncn
