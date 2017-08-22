



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




concord_channel['dctn_initial_blob'] = ({ state, action, data }) ->
    state.setIn ['dctn_blob'], data.payload.blob

concord_channel['lookup_resp'] = ({ state, action, data }) ->
    state.setIn ['match'], data.payload
    # state


concord_channel['ret_raw_dctns_list'] = ({ state, action, data }) ->
    state.setIn ['raw_dctns_list'], data.payload.raw_dctns_rayy


keys_concord_channel = keys concord_channel

arq['primus:data'] = ({ state, action }) ->
    { data } = action.payload
    { type, payload } = action.payload.data
    # c state, action, '393939'
    # c action.payload.data, payload.data
    if includes(keys_concord_channel, type)
        concord_channel[type] { state, action, data }
    else
        state



arq['apply_parse_build_data_structure'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'apply_parse_build_data_structure'
        payload: action.payload


arq['browse_dctn'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'browse_dctn'
        payload: action.payload

arq['get_raw_dctns_list'] = ({ state, action }) ->
    state = state.setIn ['desires', shortid()],
        type: 'get_raw_dctns_list'
    state.setIn ['get_dctns_list_state'], 'sent_request'

arq['lookup_prefix'] = ({ state, action }) ->
    # { prefix_text } = action.payload
    state.setIn ['desires', shortid()],
        type: 'lookup_prefix'
        payload: action.payload



keys_arq = keys arq

# counter = 0
lookup = (state, action) ->
    # c state, action
    state = state.setIn ['desires'], Imm.Map({})
    if includes(keys_arq, action.type)
        arq[action.type]({ state, action })
    else
        c 'noop with ', action.type
        state





exports.default = lookup
