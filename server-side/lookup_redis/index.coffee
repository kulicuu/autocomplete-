








test_one = fs.readFileSync(path.resolve(__dirname, './test_one.lua'))
test_two = fs.readFileSync(path.resolve(__dirname, './test_two.lua'))



api = {}



api.test_redis_lua_002 = ->
    c color.red('2324', on)
    redis.eval test_two, 0, (err, res) ->
        c err, 'err'
        c res, 'res'

api.test_redis_lua_001 = ->
    c color.green('888')
    redis.eval test_one, 0, (err, res) ->
        c err, 'err'
        c res, 'res'





# keys_lookup_redis_api = _.keys lookup_redis_api
#
#
# lookup_redis_api_func = ({ import_stuff }) ->
#
#     ({ type, payload }) ->
#         if _.includes(keys_lookup_redis_api, type)
#             lookup_redis_api[type] payload
#         else
#             c "#{color.yellow('no op in lookup redis api', on)}"



exports.default = api
