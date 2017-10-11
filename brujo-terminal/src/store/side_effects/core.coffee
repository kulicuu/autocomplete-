

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


# NOTE: this one has identical implementation as 'primus_hotwire'
# but differentiated to illuminate that these have been intercepted at the
# reducer/update level.
arq['gen_primus'] = ({ desire, state }) ->
    { type, payload } = desire.payload
    primus.write { type, payload }


arq['primus_hotwire'] = ({ desire, state }) ->
    { type, payload } = desire.payload
    primus.write { type, payload }


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
