




comp = rr
    render: ->
        div
            style:
                display: 'flex'
                flexDirection: 'column'
                minWidth: .6 * ww
                alignItems: 'center'
                justifyContent: 'flexStart'
                margin: .032 * ww
                backgroundColor: 'lavender'

            input
                style:
                    textAlign: 'center'
                    color: 'darkslategrey'
                    margin: .024 * wh
                type: 'text'
                placeholder: 'type word here'
                onChange: (e) =>
                    @props.search_prefix_tree
                        prefix: e.currentTarget.value
            div
                style:

                    backgroundColor: 'lavenderblush'
                _.map @props.prefix_tree_match, (item, idx) ->
                    span
                        key: "prefix_tree_match_item:#{idx}"
                        style:
                            fontSize: .016 * wh
                            color: 'magenta'
                            fontFamily: 'sans'
                        # item.match_word + " "
                        item + " "


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    search_prefix_tree : ({ prefix }) ->
        dispatch
            type: 'primus_hotwire'
            payload:
                type: 'search_prefix_tree'
                payload:
                    client_ref: 'placeholder'  # another client ref.
                    tree_id: 'placeholder'   # will identify exactly which tree to search
                    prefix: prefix




exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
