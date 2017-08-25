




node_mem_arq = {}


build_selection = {}


build_selection['BK-tree'] = require('./bk-tree.coffee').default

build_selection['prefix-tree'] = Bluebird.promisify ({ payload }, cb) ->
    c '222'

keys_build_selection = _.keys build_selection


nodemem_api = {}


nodemem_api['build_selection'] = Bluebird.promisify ({ type, payload }, cb) ->
    c "#{color.purple('888888888883738', on)}"
    c _.keys payload
    { data_struct_type_select, dctn_hash } = payload
    # c _.keys dctn_hash
    if _.includes(keys_build_selection, data_struct_type_select)
        build_selection[data_struct_type_select] { blob: dctn_hash.blob }
        .then ({ payload }) ->
            node_mem_arq[data_struct_type_select] = payload.built_struct
            cb null, { payload }




keys_nodemem_api = _.keys nodemem_api


nodemem_api_fncn = Bluebird.promisify ({ type, payload }, cb) ->
    if _.includes(keys_nodemem_api, type)
        nodemem_api[type] { payload }
        .then ({ payload }) -> # is this a code smell ?  two payloads one overwriting the other ?
        # i think it is but it would be worse to have awkward names for the response, ...
            c '88888888'
            cb null, { payload }
    else
        c "#{color.yellow('no-op in nodemem_apip.', on)}"






exports.default = nodemem_api_fncn
