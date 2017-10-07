

dash_000 = rc require('../scenes/dash_000.coffee').default

dash_002 = rc require('../scenes/dash_002.coffee').default


render = ->
    # dash_000()
    dash_002()

comp = rr
    render: render

map_state_to_props = (state) ->
    {}

map_dispatch_to_props = (dispatch) ->
    {}

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
