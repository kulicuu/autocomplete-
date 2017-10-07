




nav_bar = rc require('./shared_comps/nav_bar.coffee').default



comp = rr

    render: ->
        { ww, wh } = @props
        nav_bar { ww, wh }
        





map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
