

cache_api = require

api = {}

{ get_dctn_raw }  = require('../cache_redis/dctn_002')


api.prefix_tree_build_tree = ({ payload, spark }) ->
    { dctn_name, job_id } = payload
    # mock the name for now
    dctn_name = 'd3.txt'
    get_dctn_raw { dctn_name }
    .then ({ dctn_blob }) ->
        c "send to drone process for parsing", dctn_blob






exports.default = api
