

{ concord_api, dctn_api } = require('./dctn_stuff.coffee')


api = {} # change name to something like 'api'
api = fp.assign api, dctn_api


concord_channel = {}
concord_channel = fp.assign concord_channel, concord_api # TODO converge the naming in favor of concord_api or better yet something more descriptive


keys_concord_channel = keys concord_channel
api['primus:data'] = ({ state, action }) ->
    { data } = action.payload
    { type, payload } = action.payload.data
    if includes(keys_concord_channel, type)
        concord_channel[type] { state, action, data }
    else
        state


# these that require primus write sideeffects can be
# handled by a single function from now on so additions
# should require code edits in fewer places.
api['primus_hotwire'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'primus_hotwire'
        payload: action.payload


api['search_struct'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'search_struct_nodemem'
        payload: action.payload


api['build_selection'] = ({ state, action }) ->
    { data_src_select, data_struct_type_select, client_job_id } = action.payload
    state = state.setIn ['jobs', client_job_id], Imm.Map
        data_src_select: data_src_select
        data_struct_type_select: data_struct_type_select
        client_job_id: client_job_id
        perc_count: 0
        build_status: 'building'
        commence_time: Date.now()
    state.setIn ['desires', shortid()],
        type: 'build_selection'
        payload: action.payload


api.set_dctn_selected = ({ state, action }) ->
    # c 'action.payload',
    dctn_selected = action.payload.dctn_name
    # c 'in reducer dctn_selected', dctn_selected
    state = state.setIn ['dctn_selected'], dctn_selected
    state


api['browse_dctn'] = ({ state, action }) ->
    if state.getIn(['dctn_browse_src']) isnt action.payload.dctn_name
        state = state.setIn ['dctn_browse_src'], action.payload.dctn_name
        state = state.setIn ['browse_rayy'], []
    state.setIn ['desires', shortid()],
        type: 'browse_dctn'
        payload: action.payload


api['get_initial_stati'] = ({ state, action }) ->
    state = state.setIn ['desires', shortid()],
        type: 'get_initial_stati'
    state.setIn ['get_initial_stati_req_status'], 'sent_request'



api.nav_bktree = ({ state, action }) ->
    state.setIn ['view'], "bktree_view"


api.nav_prefix_tree = ({ state, action }) ->
    state.setIn ['view'], "prefix_tree_view"


keys_api = keys api


lookup = (state, action) ->
    state = state.setIn ['effects'], Imm.Map({})
    if includes(keys_api, action.type)
        api[action.type]({ state, action })
    else
        c 'noop with ', action.type
        state


exports.default = lookup
