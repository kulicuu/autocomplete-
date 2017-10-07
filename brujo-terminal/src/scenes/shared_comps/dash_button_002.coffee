
# not so customizable class using version of dash button.
# doesn't take styles as args, just takes the dispatch msg, and button text

comp = rr

    getInitialState : ->
        hovering : false

    render: ->
        # { ww, wh } = @props
        c @props
        div
            style: if @state.hovering is true
                    styles.dash_button_002_mouseover
                else
                    styles.dash_button_002
            onMouseOver: =>
                @setState
                    hovering: true
            onMouseOut: =>
                @setState
                    hovering: false
            onClick: =>
                @props.click_action @props.action_msg
            span
                style: if @state.hovering is true
                        styles.dash_button_text_002_mouseover
                    else
                        styles.dash_button_text_002
                @props.button_text
                # "hello"








map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    click_action: (action_msg) ->
        dispatch
            type: action_msg
            payload: null






exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
