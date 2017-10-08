

c = console.log.bind console
_ = require 'lodash'
path = require 'path'
fs = require 'fs'
color = require 'bash-color'
Bluebird = require 'bluebird'
flow = require 'async'
{ spawn } = require 'child_process'
Redis = require 'redis'


main_redis_setup = (cb) ->
    startup_server = ->
        main_redis_server = spawn 'gnome-terminal', ["-e", "redis-server ./redis_mgmt/main_redis.conf"]
        cb null, "Ok"

    main_redis = Redis.createClient
        port: 6464
        retry_strategy: ->
            color.green "As expected, there was no main_redis Redis server already running.", on
            startup_server()

    main_redis.on 'ready', (msg) ->
        color.yellow "There was already a main_redis Redis server running. Shutting it down, before restart.", on
        main_redis.shutdown (err) ->
            c err, 'err'
            if err
                c "#{color.red('Unforseeable error with main_redis Redis shutdown. Probably not serious, just forgot to shutdown previous instance properly.', on)}: #{err}"
            else
                startup_server()


worker_redis_setup = (cb) ->
    startup_server = ->
        main_redis_server = spawn 'gnome-terminal', ["-e", "redis-server ./redis_mgmt/worker_redis.conf"]
        cb null, "Ok"

    worker_redis = Redis.createClient
        port: 6483
        retry_strategy: ->
            color.green "As expected, there was no worker_redis Redis server already running.", on
            startup_server()

    worker_redis.on 'ready', (msg) ->
        color.yellow "There was already a worker_redis Redis server running. Shutting it down, before restart", on
        worker_redis.shutdown (err) ->
            if err
                c "#{color.red('Unforseeable error with worker_redis Redis shutdown. Probably not serious, just forgot to shutdown previous instance properly.', on)}: #{err}"
            else
                startup_server()


flow.parallel [main_redis_setup, worker_redis_setup], (err, results) ->
    if err
        c "#{color.red('Redis setup error', on)}: #{err}"
    else
        brujo_terminal_build = spawn 'gnome-terminal', ["-e", "webpack -w"],
            cwd: path.resolve(__dirname, 'brujo-terminal')

        setTimeout ->
            dev_server = spawn 'gnome-terminal', ["-e", "nodemon dev-server.coffee"],
                cwd: path.resolve(__dirname, 'server-side')
        , 1200
