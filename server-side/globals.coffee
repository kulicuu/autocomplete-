


global.fork = require('child_process').fork
global.flow = require 'async' # alias could supercede control_flow name
global.control_flow = require 'async'
global.Bluebird = require 'bluebird'
global.c = console.log.bind console
global._ = require 'lodash'
global.fp = require 'lodash/fp'
global.fs = Bluebird.promisifyAll require('fs')
global.color = require 'bash-color'
uuid = require 'node-uuid'
global.v4 = uuid.v4.bind uuid
global.path = require 'path'


Redis = require 'redis'


Bluebird.promisifyAll(Redis.RedisClient.prototype)
Bluebird.promisifyAll(Redis.Multi.prototype)


global.redis = Redis.createClient
    port: 6464
