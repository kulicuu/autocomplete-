

nav_bar = rc require('./shared_comps/nav_bar.coffee').default

counter = 0
cursive_tree_render = ({ key, node, x_place, y_place }) ->
    if counter++ < 500
        { match_word, chd_nodes } = node
        keys_chd_nodes = _.keys chd_nodes
        num_sibs = keys_chd_nodes.length
        sib_counter = 0
        g null,
            text
                x: x_place
                y: y_place
                fontSize: .01 * wh
                fontFamily: 'sans'
                fill: 'chartreuse'
                match_word
            text
                x: x_place
                y: y_place + (.012 * wh)
                fontSize: .01 * wh
                fontFamily: 'sans'
                fill: 'indigo'
                key
            circle
                cx: x_place
                cy: y_place
                r: .03 * wh
                opacity: .2
            _.map node.chd_nodes, (ch_node, key2) ->
                sib_counter++
                cursive_tree_render
                    key: key2
                    node: ch_node
                    x_place: x_place - (.4 * ww) + (((.8 * ww) / num_sibs) * sib_counter)
                    y_place: y_place + ( .1 * wh )


comp = rr
    render: ->
        c @props, 'props'
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
                width: .98 * ww
                height: .9 * wh
                ,
                # rect
                #     x: .2 * ww
                #     y: .2 * wh
                #     width: .4 * ww
                #     height: .6 * wh
                #     fill: 'magenta'
                # _.map @props.tree_cursor.string_tree, (v, k) ->
                cursive_tree_render
                    node: @props.tree_cursor
                    x_place: .5 * ww
                    y_place: .02 * wh



map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
