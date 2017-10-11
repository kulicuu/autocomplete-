

dash_000 = rc require('../scenes/dash_000.coffee').default

dash_002 = rc require('../scenes/dash_002.coffee').default # prefix tree



render = ->
    # dash_000()
    switch @props.view
        when "prefix_tree_view"
            dash_002()
        when "bktree_view"
            div null, "bktree view placeholder"
        else
            div null, "error in views nexus"

comp = rr
    render: render

map_state_to_props = (state) ->
    state.get('lookup').toJS()

map_dispatch_to_props = (dispatch) ->
    {}

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
