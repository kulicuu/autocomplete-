

arq = {}

# arq['send_edited_message'] = ({ desire, store }) ->
#     primus.write
#         type: 'send_edited_message'
#         payload: desire.payload
#
# arq['change_username'] = ({ desire, store }) ->
#     primus.write
#         type: 'change_username'
#         payload: desire.payload
#
# arq['send_message'] = ({ desire, store }) ->
#     primus.writeeo
#         type: 'send_message'
#         payload: desire.payload




arq['primus_hotwire'] = ({ desire, state }) ->
    { type, payload } = desire.payload
    primus.write { type, payload }



arq['build_selection'] = ({ desire, state }) ->
    primus.write
        type: 'build_selection'
        payload: desire.payload


arq['apply_parse_build_data_structure'] = ({ desire, state }) ->
    primus.write
        type: 'apply_parse_build_data_structure'
        payload: desire.payload


arq['get_initial_stati'] = ({ desire, state }) ->
    primus.write
        type: 'get_initial_stati'

arq['browse_dctn'] = ({ desire, state }) ->
    primus.write
        type: 'browse_dctn'
        payload: desire.payload

arq['get_raw_dctns_list'] = ({ desire, store }) ->
    primus.write
        type: 'get_raw_dctns_list'



arq['lookup_prefix'] = ({ desire, store }) ->
    { payload } = desire
    primus.write
        type: 'lookup_prefix'
        payload: payload
        lookup: true

arq['init_primus'] = ({ desire, store }) ->
    c 'primus initialising'
    primus.on 'data', (data) ->
        c 'primus data:', data
        store.dispatch
            type: 'primus:data'
            payload: { data }

    # setInterval =>
    #     primus.write
    #         type: 'request_orient'
    # , 300


exports.default = arq
