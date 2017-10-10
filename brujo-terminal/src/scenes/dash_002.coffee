

nav_bar = rc require('./shared_comps/nav_bar.coffee').default
dctn_browser = rc require('./shared_comps/dctn_browser.coffee').default
text_entry_feedback = rc require('./shared_comps/text_entry_feedback.coffee').default


comp = rr
    render: ->
        div null,
            nav_bar()
            div
                style:
                    display: 'flex'
                dctn_browser()
                text_entry_feedback()


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
