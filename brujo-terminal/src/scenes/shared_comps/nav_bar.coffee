

# TODO : pass the ww, wh thing maybe globally instead of through the whole component chain,
# it's just so much repetitive typing for one thing.


dash_button_000 = rc require('./dash_button_000.coffee').default
dash_button_002 = rc require('./dash_button_002.coffee').default


comp = rr
    render: ->
        div
            style:
                display: 'flex'
                alignItems: 'center'
                justifyContent: 'center'
                backgroundColor: 'gainsboro'
                width: '100%'
                height: '10%'

            dash_button_002
                action_msg: 'nav_dash_444'
                button_text: 'dash-444'

            dash_button_002
                action_msg: 'nav_dash_555'
                button_text: 'dash-555'


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)