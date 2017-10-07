





dash_button_000 = rc require('./dash_button_000.coffee').default
dash_button_002 = rc require('./dash_button_002.coffee').default


comp = rr


    render: ->
        { ww, wh } = @props
        div
            style:
                display: 'flex'
                backgroundColor: 'gainsboro'
                width: '100%'
                height: '10%'
            dash_button_000
                ww: ww
                wh: wh
                base_color: 'lemonchiffon'
                mouseover_color: 'magenta'
                action_msg: 'nav_dash_222'
                button_text: 'go dash-222'
                text_color: 'darkslategrey'
                mouseover_text_color: 'white'

            dash_button_000
                ww: ww
                wh: wh
                base_color: 'blanchedalmond'
                mouseover_color: 'magenta'
                action_msg: 'nav_dash_333'
                button_text: 'go dash-333'
                text_color: 'darkslategrey'
                mouseover_text_color: 'white'

            dash_button_002
                action_msg: 'nav_dash_444'
                button_text: 'go dash-444'

            dash_button_002
                action_msg: 'nav_dash_555'
                button_text: 'go dash-555'







map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}






exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
