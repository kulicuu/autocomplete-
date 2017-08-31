



arq = {}


# arq['send_edited_message'] = ({ state, action }) ->
#     c 'action in editing message', action
#     state = state.setIn ['desires', shortid()],
#         type: 'send_edited_message'
#         payload: action.payload
#     state
#
# arq['change_username'] = ({ state, action }) ->
#     state.setIn ['desires', shortid()],
#         type: 'change_username'
#         payload: action.payload
#
# arq['send_message'] = ({ state, action }) ->
#     state.setIn ['desires', shortid()],
#         type: 'send_message'
#         payload: action.payload
#
#
#
# arq['init:primus'] = ({ state, action }) ->
#     state.setIn ['desires', shortid()],
#         type: 'init:primus'
#         payload: null
#
#
#
# arq['request_orient'] = ({ state, action }) ->
#     state.setIn ['desires', shortid()],
#         type: 'request_orient'
#         payload: null


# concord_channel = require('./lounger/concorde_channel.coffee').default


concord_channel = {}


concord_channel['res_browse_raw_dctn'] = ({ state, action, data }) ->
    { browse_rayy } = data.payload
    # c browse_rayy
    # c state.toJS(), '11111111111111111'
    # c old_rayy, 'old rayy'
    old_rayy = state.getIn ['browse_rayy']
    if old_rayy isnt undefined
        # c 'green'
        mid_rayy = [].concat old_rayy
        mid_rayy = mid_rayy.concat browse_rayy
        # c mid_rayy, 'mid_rayy'
        state = state.setIn ['browse_rayy'], mid_rayy
        state
    else
        # c 'red'
        state = state.setIn ['browse_rayy'], browse_rayy
        state


concord_channel['dctn_initial_blob'] = ({ state, action, data }) ->
    state.setIn ['dctn_blob'], data.payload.blob

concord_channel['lookup_resp'] = ({ state, action, data }) ->
    state.setIn ['match'], data.payload


concord_channel['res_get_raw_dctns_list'] = ({ state, action, data }) ->
    c data.payload, 'data.payload in res_get_raw_dctns_list'
    state = state.setIn ['get_dctns_list_state'], 'received_it'
    state.setIn ['raw_dctns_list'], data.payload


keys_concord_channel = keys concord_channel


arq['primus:data'] = ({ state, action }) ->
    { data } = action.payload
    { type, payload } = action.payload.data
    if includes(keys_concord_channel, type)
        concord_channel[type] { state, action, data }
    else
        state


arq['build_selection'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'build_selection'
        payload: action.payload


arq['apply_parse_build_data_structure'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'apply_parse_build_data_structure'
        payload: action.payload


arq['browse_dctn'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'browse_dctn'
        payload: action.payload


arq['get_initial_stati'] = ({ state, action }) ->
    state = state.setIn ['desires', shortid()],
        type: 'get_initial_stati'
    state.setIn ['get_initial_stati_req_status'], 'sent_request'


arq['get_raw_dctns_list'] = ({ state, action }) ->
    state = state.setIn ['desires', shortid()],
        type: 'get_raw_dctns_list'
    state.setIn ['get_dctns_list_state'], 'sent_request'


arq['lookup_prefix'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'lookup_prefix'
        payload: action.payload


keys_arq = keys arq


lookup = (state, action) ->
    state = state.setIn ['desires'], Imm.Map({})
    if includes(keys_arq, action.type)
        arq[action.type]({ state, action })
    else
        c 'noop with ', action.type
        state


exports.default = lookup
