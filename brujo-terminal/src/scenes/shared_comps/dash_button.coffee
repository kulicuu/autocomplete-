


comp = rr

    getInitialState : ->
        c 'initial State has props', @props
        {}

    render: ->
        { ww, wh, base_color, hover_color } = @props
        div
            style: fp.assign styles.dash_button,
                backgroundColor : @props.base_color







map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}






exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
