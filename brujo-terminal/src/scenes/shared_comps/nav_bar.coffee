

# TODO : pass the ww, wh thing maybe globally instead of through the whole component chain,
# it's just so much repetitive typing for one thing.


# dash_button_000 = rc require('./dash_button_000.coffee').default
nav_button_002 = rc require('./nav_button_002.coffee').default


comp = rr
    render: ->
        div
            style: styles.nav_bar()

            nav_button_002
                action_msg: 'nav_prefix_tree'
                button_text: 'autocomplete'

            # nav_button_002
            #     action_msg: 'nav_bktree'
            #     button_text: 'spellcheck'


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
