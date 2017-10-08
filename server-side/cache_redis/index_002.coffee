


api = {}


# verify/establish raw dctn in redis
require './basis'


api = fp.assign api, require('./dctn_002').default


exports.default = api
