











lookup_redis_api = {}



keys_lookup_redis_api = _.keys lookup_redis_api


lookup_redis_api_func = ({ import_stuff }) ->

    ({ type, payload }) ->
        if _.includes(keys_lookup_redis_api, type)
            lookup_redis_api[type] payload
        else
            c "#{color.yellow('no op in lookup redis api', on)}"
