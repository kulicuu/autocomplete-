



build_selection = {}


build_selection['BK-tree'] = require('./bk-tree.coffee').default

build_selection['prefix-tree'] = Bluebird.promisify ({ payload }, cb) ->
    c '222'

keys_build_selection = _.keys build_selection


nodemem_api = {}


nodemem_api['build_selection'] = Bluebird.promisify ({ type, payload }) ->
    c "#{color.purple('888888888883738', on)}"
    c payload
    { data_struct_type_select, data_src_select } = payload
    if _.includes(keys_build_selection, data_struct_type_select)
        build_selection[data_struct_type_select] { data_src_select }
        .then ({ payload }) ->
            cb null, { payload }




keys_nodemem_api = _.keys nodemem_api


nodemem_api_fncn = Bluebird.promisify ({ type, payload }) ->
    if _.includes(keys_nodemem_api, type)
        nodemem_api[type] { payload }
        .then ({ payload }) -> # is this a code smell ?  two payloads one overwriting the other ?
        # i think it is but it would be worse to have awkward names for the response, ...
            cb null, { payload }
    else
        c "#{color.yellow('no-op in nodemem_apip.', on)}"






exports.default = nodemem_api_fncn
