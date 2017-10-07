
# More customizable button that takes colors as parameters.  Will favor usage of the 002 version which favors
# style classes

comp = rr

    getInitialState : ->
        background_color : @props.base_color
        text_color : @props.text_color

    render: ->
        { ww, wh } = @props
        div
            style: fp.assign styles.dash_button,
                backgroundColor : @state.background_color
            onMouseOver: =>
                @setState
                    background_color: @props.mouseover_color
                    text_color: @props.mouseover_text_color
            onMouseOut: =>
                @setState
                    background_color: @props.base_color
                    text_color: @props.text_color
            onClick: =>
                @props.click_action @props.action_msg
            span
                style: fp.assign styles.dash_button_text({ ww, wh }),
                    color: @state.text_color
                @props.button_text








map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    click_action: (action_msg) ->
        dispatch
            type: action_msg
            payload: null






exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
