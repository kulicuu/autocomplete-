# NOTE there will be a ton of functions here which will find broadly some grouping.
# this is basically a Controller function.



# { redis_caching_api, redis_lookup_api } = require('../redis_layer/index')
# this may well contain


cache_redis_api = require('../cache_redis/index').default



brujo_api = {}


brujo_api["get_raw_dctns_list"] = ({ type, spark }) ->
    cache_redis_api { type }
    .then ({ payload }) ->
        c payload, 'payload'
        { ret_rayy } = payload
        c 'goit i', ret_rayy

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
