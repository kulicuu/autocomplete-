

api = {}


api['gen_primus'] = ({ effect, state }) ->
    { type, payload } = desire.payload
    primus.write { type, payload }


api['primus_hotwire'] = ({ effect, state }) ->
    { type, payload } = desire.payload
    primus.write { type, payload }


api['init_primus'] = ({ effect, store }) ->
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


exports.default = api
