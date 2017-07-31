


require './globals.coffee'

c = console.log.bind console
_ = require 'lodash'
express = require 'express'
cookie_parser = require 'cookie-parser'
color = require 'bash-color'
path = require 'path'
fs = require 'fs'
http = require 'http'
Primus = require 'primus'


brujo_arq = do ->
    cookie_parser_secret = 'very secret 388383824'
    cookies = cookie_parser cookie_parser_secret
    cookie_parser_secret: cookie_parser_secret
    cookies: cookies
    public_dir: path.resolve('..', 'brujo-terminal', 'public')
    index_path: '/dev_index.html'
    port: 2229
    primus_opts:
        transformer: 'websockets'


express_session = require 'express-session'
connect_redis = require 'connect-redis'
Redis_Store = connect_redis express_session

brujo_redis_store_opts = {}
brujo_redis_store = new Redis_Store(brujo_redis_store_opts)


primus_session = (options) ->
    key = options.key or 'connect.sid'
    store = options.store
    primus = @
    if not(store)
        message = 'Session middleware configuration failed due to missing store option.'
        throw new Error(message)
    (req, res, next) ->
        sid = req.signedCookies[key]
        req.session = {}
        if not(sid) then return next()
        store.get sid, (err, session) ->
            if err
                primus.emit 'log', 'error', err
                return next()
            if session then req.session = session
            next()


app_brujo = express()


app_brujo.all '/', (req, res, next) ->
    c color.purple(req.url)
    res.sendFile path.join(brujo_arq.public_dir, brujo_arq.index_path)


app_brujo.use express.static(brujo_arq.public_dir)


brujo_server = http.createServer app_brujo

opts_brujo_primus =
    transformer: 'websockets'

brujo_primus = new Primus(brujo_server, brujo_arq.primus_opts)

brujo_primus.use 'cookies', brujo_arq.cookies
brujo_primus.use 'session', primus_session, { store: brujo_redis_store }
brujo_primus.save path.join(brujo_arq.public_dir, '/js' , '/primus.js')


the_api = require('./lookup_api/index').default


brujo_server.listen brujo_arq.port, ->
    c 'server on', brujo_arq.port


brujo_primus.on 'connection', (spark) ->
    # dispatch to concord if want state
    spark.on 'data', (data) ->
        if _.includes(_.keys(data), 'lookup')
            spark.write
                type: 'lookup_resp'
                payload: the_api
                    prefix: data.payload.prefix_text
                    opts:
                        lookup_type: 'lookup_prefix_000'
