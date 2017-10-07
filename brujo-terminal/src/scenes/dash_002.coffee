

nav_bar = rc require('./shared_comps/nav_bar.coffee').default
dctn_browser = rc require('./shared_comps/dctn_browser.coffee').default


comp = rr
    render: ->
        div null,
            nav_bar()
            dctn_browser()


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
