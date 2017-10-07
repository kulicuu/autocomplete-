





dash_button = rc require('./dash_button.coffee').default


comp = rr


    render: ->
        { ww, wh } = @props
        div
            style:
                display: 'flex'
                backgroundColor: 'lightgreen'
                width: '100%'
                height: '10%'
            div
                style: fp.assign styles.dash_button,
                    backgroundColor: 'gainsboro '

            dash_button
                ww: ww
                wh: wh
                base_color: 'blanchedalmond'







map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}






exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
