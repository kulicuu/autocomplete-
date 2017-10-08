

c = console.log.bind console
_ = require 'lodash'
path = require 'path'
fs = require 'fs'
color = require 'bash-color'
Bluebird = require 'bluebird'
flow = require 'async'
{ spawn } = require 'child_process'
Redis = require 'redis'


redis = Redis.createClient
    retry_strategy:  ->
        c "As expected, there was no Redis server already running.", arguments
        "cancel attempt"

        main_redis_server = spawn 'gnome-terminal', ["-e", "redis-server"]

        brujo_terminal_build = spawn 'gnome-terminal', ["-e", "webpack -w"],
            cwd: path.resolve(__dirname, 'brujo-terminal')

        # give the redis-server time to startup first
        setTimeout ->
            dev_server = spawn 'gnome-terminal', ["-e", "nodemon dev-server.coffee"],
                cwd: path.resolve(__dirname, 'server-side')
        , 1200



redis.on 'ready', (msg) ->
    c 'Already a redis server running, shutting it down...', msg
    redis.shutdown (err) ->
        if err
            color.red "Unexpected Error with redis shutdown."
        else
            main_redis_server = spawn 'gnome-terminal', ["-e", "redis-server"]

            brujo_terminal_build = spawn 'gnome-terminal', ["-e", "webpack -w"],
                cwd: path.resolve(__dirname, 'brujo-terminal')

            # give the redis-server time to startup first
            setTimeout ->
                dev_server = spawn 'gnome-terminal', ["-e", "nodemon dev-server.coffee"],
                    cwd: path.resolve(__dirname, 'server-side')
            , 1200
