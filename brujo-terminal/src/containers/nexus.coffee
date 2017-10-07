

brujo_dash_000 = rc require('../scenes/brujo_dash_000.coffee').default

brujo_dash_002 = rc require('../scenes/brujo_dash_002.coffee').default



render = ->
    { ww, wh } = @props
    brujo_dash_002 { ww, wh }

comp = rr
    render: render

map_state_to_props = (state) ->
    {}

map_dispatch_to_props = (dispatch) ->
    {}

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
