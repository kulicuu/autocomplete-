




comp = rr
    render: ->
        c @props.match, '@props.match'
        div
            style:
                display: 'flex'
                flexDirection: 'column'
                alignItems: 'center'
                justifyContent: 'center'
                backgroundColor: 'ivory'
                height: '100%'
            input
                type: 'text'
                # color: 'grey'
                onChange: (e) =>
                    c 'e', e.currentTarget.value
                    @props.lookup_prefix
                        payload:
                            prefix_text: e.currentTarget.value
                placeholder: 'prefix'

            h3
                style:
                    fontSize: 14
                    color: 'grey'
                if (@props.match is 'Not found.') or (@props.match is '')
                    @props.match
                else
                    @props.match.match_word











map_state_to_props = (state) ->
    state.get('lookup').toJS()

map_dispatch_to_props = (dispatch) ->

    lookup_prefix: ({ payload }) ->
        dispatch
            type: 'lookup_prefix'
            payload: payload

    placeholder: ({ payload }) ->
        dispatch
            type: 'placeholder'


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
