

nav_bar = rc require('./shared_comps/nav_bar.coffee').default
dctn_browser = rc require('./shared_comps/dctn_browser.coffee').default


comp = rr
    render: ->
        div null,
            nav_bar()
            dctn_browser()

            button
                onClick: @props.prefix_tree_build_tree
                "test 888"


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    prefix_tree_build_tree : ->
        dispatch
            type: 'primus_hotwire'
            payload:
                type: 'prefix_tree_build_tree'
                payload:
                    dctn_name: 'd3.txt'


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
