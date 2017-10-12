

nav_bar = rc require('./shared_comps/nav_bar.coffee').default

comp = rr
    render: ->
        div
            style:
                display: "flex"
                flexDirection: "column"
            nav_bar()
            div
                style:
                    display: "flex"
                    color: "chartreuse"
                    alignItems: "center"
                    justifyContent: "center"
                "graph radar"
            svg
                width: .9 * ww
                height: .8 * wh
                ,
                rect
                    x: .2 * ww
                    y: .2 * wh
                    width: .4 * ww
                    height: .6 * wh
                    fill: 'magenta'
                # _.map @props.tree_cursor.string_tree, (v, k) ->



map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
