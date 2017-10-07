

cache_redis_api = {}


cache_redis_api = _.assign cache_redis_api, require('./basis').default
cache_redis_api = _.assign cache_redis_api, require('./dctn').default


keys_cache_redis_api = _.keys cache_redis_api


cache_redis_api_fn = Bluebird.promisify ({ type, payload }, cb) ->
    if _.includes(keys_cache_redis_api, type)
        cache_redis_api[type] { payload }
        .then (payload) ->
            cb null, { payload }
    else
        c "#{color.yellow('no op in cache-redis-api.', on)}", "#{color.cyan(type, on)}"


exports.default = cache_redis_api_fn
