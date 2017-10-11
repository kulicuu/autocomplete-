

concord_channel = {}


concord_channel.progress_update_prefix_tree_build = ({ state, action, data }) ->
     { perc_count, client_ref } = data.payload
     state = state.setIn ['jobs', client_ref, 'perc_count'],
        perc_count
     state


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


concord_channel['res_get_raw_dctns_list'] = ({ state, action, data }) ->
    state = state.setIn ['get_dctns_list_state'], 'received_it'
    state.setIn ['raw_dctns_list'], data.payload


concord_channel.prefix_tree_match_report = ({ state, action, data }) ->
    { match_set } = data.payload
    state.setIn ['prefix_tree_match'], match_set


concord_channel['build_progress_update'] = ({ state, action, data }) ->
    { client_job_id, perc_count } = data.payload
    if perc_count is 100
        state = state.setIn ['jobs', client_job_id, 'build_status'], 'completed_build'
    state.setIn ['jobs', client_job_id, 'perc_count'], perc_count



api = {}



# api['get_raw_dctns_list'] = ({ state, action }) ->
#     state = state.setIn ['desires', shortid()],
#         type: 'get_raw_dctns_list'
#     state.setIn ['get_dctns_list_state'], 'sent_request'


api.prefix_tree_build_tree = ({ state, action }) ->
    { dctn_name } = action.payload
    client_ref = shortid()
    state = state.setIn ['jobs', client_ref], Imm.Map
        job_type: "prefix_tree from: #{dctn_name}"
        perc_count: 0
    state.setIn ['desires', shortid()],
        type: 'gen_primus'
        payload:
            type: 'prefix_tree_build_tree'
            payload: { dctn_name, client_ref }









exports.dctn_api = api


exports.concord_api = concord_channel
