

c = console.log.bind console
_ = require 'lodash'
path = require 'path'
fs = require 'fs'
color = require 'bash-color'
Bluebird = require 'bluebird'
flow = require 'async'


{ spawn } = require 'child_process'


main_redis_server = spawn 'gnome-terminal', ["-e", "/home/s/redis-4.0.1/src/redis-server"]


dev_server = spawn 'gnome-terminal', ["-e", "nodemon dev-server.coffee"],
    cwd: path.resolve(__dirname, 'server-side')


brujo_terminal_build = spawn 'gnome-terminal', ["-e", "webpack -w"],
    cwd: path.resolve(__dirname, 'brujo-terminal')
