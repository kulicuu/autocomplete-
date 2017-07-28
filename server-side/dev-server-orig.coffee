dev__server = ({ env, cs, c, redis }) ->
    shortid = require 'shortid'
    c = co = console.log.bind console # replace with c when structured moved to cs
    uuid = require 'node-uuid'
    v4 = uuid.v4.bind uuid
    color = require 'bash-color'
    body_parser = require 'body-parser'
    cookie_parser = require 'cookie-parser'
    express = require 'express'
    _ = require 'lodash'
    fs = require 'fs'
    path = require 'path'
    http = require 'http'
    Primus = require 'primus'
    {
        keys, assign, map, reduce
    } = _

    apa = do -> # app__proto__arq
        cookie__parser__secret = "nasntoeuhht34nh"
        cookies = cookie_parser cookie__parser__secret
        cookie__parser__secret: cookie__parser__secret
        cookies: cookies
        public_dir: path.resolve('..', 'WebApps', 'Proto__User', 'public')
        index_path: '/dev_index_.html'
        primus_dir: path.resolve('..', 'WebApps', 'Proto__User', 'public', 'js')

    aba = do -> # app__brujo__arq
        cookie__parser__secret = "nashtndnthd34nh"
        cookies = cookie_parser cookie__parser__secret
        cookie__parser__secret: cookie__parser__secret
        cookies: cookies
        public_dir: path.resolve('..', 'WebApps', 'Brujo__Terminal', 'public')
        index_path: '/dev_index_.html'
        primus_dir: path.resolve('..', 'WebApps', 'Brujo__Terminal', 'public', 'js')

    primus_session_F = require './primus_session_000_.coffee'

    app__proto = express()
    app__brujo = express()

    express__session = require 'express-session'
    connect__redis = require 'connect-redis'
    Redis__Store = connect__redis express__session

    proto_redis_store_opts = {}
    proto__redis__store = new Redis__Store(proto_redis_store_opts)

    brujo_redis_store_opts = {}
    brujo__redis__store = new Redis__Store(brujo_redis_store_opts)

    proto__store__arq =
        resave: true
        saveUninitialized: true
        store: proto__redis__store
        secret: apa.cookie__parser__secret

    brujo__store__arq =
        resave: true
        saveUninitialized: true
        store: brujo__redis__store
        secret: aba.cookie__parser__secret

    app__proto.use apa.cookies
    app__proto.use express__session(proto__store__arq)
    app__proto.use '/js', express.static(path.join(apa.public_dir, '/js'))
    app__proto.use '/css', express.static(path.join(apa.public_dir, '/css'))
    app__proto.use '/images', express.static(path.join(apa.public_dir, '/images'))
    app__proto.use '/fonts', express.static(path.join(apa.public_dir, '/fonts'))
    app__proto.use '/svgs', express.static(path.join(apa.public_dir, '/svgs'))

    app__brujo.use aba.cookies
    app__brujo.use express__session(brujo__store__arq)
    app__brujo.use '/js', express.static(path.join(aba.public_dir, '/js'))
    app__brujo.use '/css', express.static(path.join(aba.public_dir, '/css' ))
    app__brujo.use '/images', express.static(path.join(aba.public_dir, '/images'))
    app__brujo.use '/fonts', express.static(path.join(aba.public_dir, '/fonts'))
    app__brujo.use '/svgs', express.static(path.join(aba.public_dir, '/svgs'))

    app__proto.all '/*', (req, res, next) ->
        if not(includes(keys(req.cookies), 'caracal'))
            res.cookie 'caracal', "eureka::#{v4()}"
        res.sendFile path.join(apa.public_dir, apa.index_path)

    app__brujo.all '/*', (req, res, next) ->
        res.sendFile path.join(aba.public_dir, aba.index_path)

    app__proto.use express.static(apa.public_dir)
    app__brujo.use express.static(aba.public_dir)

    app__proto__port = 6494
    app__brujo__port = 2239

    app_proto_server = http.createServer app__proto
    app_brujo_server = http.createServer app__brujo

    opts_proto_primus =
        transformer: 'websockets'

    opts_brujo_primus =
        transformer: 'websockets'

    proto__primus = new Primus(app_proto_server, opts_proto_primus)
    brujo__primus = new Primus(app_brujo_server, opts_brujo_primus)

    # proto__primus.plugin 'mirage', require('mirage')
    # primus.plugin('mirage', require('mirage'))

    proto__primus.use 'cookies', apa.cookies
    brujo__primus.use 'cookies', aba.cookies

    proto__primus.use 'session', primus_session_F, { store: proto__redis__store }
    brujo__primus.use 'session', primus_session_F, { store: brujo__redis__store }

    proto__primus.save path.join(apa.primus_dir, '/primus.js')
    brujo__primus.save path.join(aba.primus_dir, '/primus.js')

    # { state__cache } = env or {}

    require('../Concorde__/index__910__.coffee')({ cs, env, proto__primus, brujo__primus, redis })

    app_proto_server.listen app__proto__port, ->
        co color.blue('⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒⇒', on), color.cyan(app__proto__port, on)

    app_brujo_server.listen app__brujo__port, ->
        co color.green('∋∋∋∋∋∋∋∋∋∋∋∋∋∋∋∋∋∋∋', on), color.white(app__brujo__port, on)

require('../Concorde__/modules/startup__transcendents__.coffee') { dev__server }

# invocation = "
# nodemon --watch ../Concorde__029 complex__064__dev__.coffee
# or
# nodemon --watch . --watch ../Concorde__029 complex__064__dev__.coffee
# "
