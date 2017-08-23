

global.c = console.log.bind console
global._ = require 'lodash'
global.fs = require 'fs'
global.color = require 'bash-color'
global.assert = require 'assert'


api = require('./index.coffee').default


node_0 = api
    prefix: 'gce'
    opts:
        lookup_type: 'lookup_prefix_000'


c node_0
assert node_0 is 'Not found.'


node_1 = api
    prefix: 'ze'
    opts:
        lookup_type: 'lookup_prefix_000'


c node_1
assert node_1.match_word is 'zebra'
