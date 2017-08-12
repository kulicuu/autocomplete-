

# NOTE The UI support for features:
# 1.  loading dictionary file from disc, caching raw in redis as a string, in the
# main meta hash of that.


comp = rr
    render: ->
        # c @props.match, '@props.match'
        div
            style:
                display: 'flex'
                flexDirection: 'column'
                alignItems: 'center'
                justifyContent: 'center'
                backgroundColor: 'ivory'
                height: '100%'
            div
                style:
                    display: 'flex'

                button
                    style:
                        background: 'red'
                    'autocomplete'
                button
                    onClick: =>
                        @props.change_to_spellcheck_mode
                    style:
                        background: 'cyan'
                    'spellcheck'
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


    change_to_autocomplete_mode: ->
        dispatch
            type: 'change_to_autocomplete_mode'

    change_to_spellcheck_mode: ->
        dispatch
            type: 'change_to_spellcheck_mode'


    lookup_prefix: ({ payload }) ->
        dispatch
            type: 'lookup_prefix'
            payload: payload

    placeholder: ({ payload }) ->
        dispatch
            type: 'placeholder'


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
