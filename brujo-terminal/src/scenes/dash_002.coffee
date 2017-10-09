

nav_bar = rc require('./shared_comps/nav_bar.coffee').default
dctn_browser = rc require('./shared_comps/dctn_browser.coffee').default


comp = rr
    render: ->
        div null,
            nav_bar()
            dctn_browser()
            div
                style:
                    display: 'flex'
                button
                    onClick: =>
                        @props.prefix_tree_build_tree
                            dctn_selected: @props.dctn_selected
                    "test 888"
                input
                    type: 'text'
                    placeholder: 'prefix autocomplete'
                    onChange: (e) =>
                        @props.search_prefix_tree
                            prefix: e.currentTarget.value
                div null,
                    _.map @props.prefix_tree_match, (item, idx) ->
                        span
                            key: "prefix_tree_match_item:#{idx}"
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

    prefix_tree_build_tree : ({ dctn_selected }) ->
        dispatch
            type: 'primus_hotwire'
            payload:
                type: 'prefix_tree_build_tree'
                payload:
                    dctn_name: dctn_selected or 'd3.txt'


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
