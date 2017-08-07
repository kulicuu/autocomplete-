




global.async = require 'async'
global.Bluebird = require 'bluebird'
global.c = console.log.bind console
global._ = require 'lodash'
global.fs = require 'fs'
global.color = require 'bash-color'


Redis = require 'redis'




Bluebird.promisifyAll(Redis.RedisClient.prototype)
Bluebird.promisifyAll(Redis.Multi.prototype)


global.redis = Redis.createClient()
