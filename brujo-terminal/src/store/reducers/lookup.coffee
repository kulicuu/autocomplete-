



arq = {}


concord_channel = {}


concord_channel['build_progress_update'] = ({ state, action, data }) ->
    c '938838383829929292'
    c data.payload
    { client_job_id, perc_count } = data.payload
    c state.get('jobs').toJS()
    state = state.setIn ['jobs', client_job_id, 'perc_count'], perc_count
    state


concord_channel['res_search_struct_nodemem'] = ({ state, action, data }) ->
    state.setIn ['search_results'], data.payload.search_results


concord_channel['res_browse_raw_dctn'] = ({ state, action, data }) ->
    { browse_rayy } = data.payload
    old_rayy = state.getIn ['browse_rayy']
    if old_rayy isnt undefined
        mid_rayy = [].concat old_rayy
        mid_rayy = mid_rayy.concat browse_rayy
        state = state.setIn ['browse_rayy'], mid_rayy
        state
    else
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


# these that require primus write sideeffects can be
# handled by a single function from now on so additions
# should require code edits in fewer places.
arq['primus_hotwire'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'primus_hotwire'
        payload: action.payload


arq['search_struct'] = ({ state, action }) ->
    state.setIn ['desires', shortid()],
        type: 'search_struct_nodemem'
        payload: action.payload


arq['build_selection'] = ({ state, action }) ->
    { data_src_select, data_struct_type_select, client_job_id } = action.payload
    state = state.setIn ['jobs', client_job_id], Imm.Map
        data_src_select: data_src_select
        data_struct_type_select: data_struct_type_select
        client_job_id: client_job_id
        perc_count: 0
        build_status: 'building'
    state.setIn ['desires', shortid()],
        type: 'build_selection'
        payload: action.payload


arq['browse_dctn'] = ({ state, action }) ->
    if state.getIn(['dctn_browse_src']) isnt action.payload.dctn_name
        state = state.setIn ['dctn_browse_src'], action.payload.dctn_name
        state = state.setIn ['browse_rayy'], []
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
