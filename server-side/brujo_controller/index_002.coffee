

api = {}

redis_lua_lookup_api = require('../lookup_redis/index').default
api = fp.assign api, redis_lua_lookup_api

redis_naive_cache_api = require('../cache_redis/index_002').default
api = fp.assign api, redis_naive_cache_api








keys_api = _.keys api


api_gate = ({ type, payload, spark }) ->
    if _.includes(keys_api, type)
        api[type] { payload, spark }
    else
        c "#{color.yellow('No-Op in Brujo-Controller with type: ', on)} #{color.white(type, on)}"


exports.default = api_gate
