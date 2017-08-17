

# NOTE The UI support for features:
# 1.  loading dictionary file from disc, caching raw in redis as a string, in the
# main meta hash of that.



select_file_load = (props, state) ->
    div
        style:
            display: 'flex'
            background: 'lime'
            width: 200
            height: 300



browse_pane = (props, state) ->
    div
        style:
            display: 'flex'
            background: 'blue'
        textarea
            width: 100
            height: 100



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

                div
                    style:
                        display: 'flex'
                        background: 'deepseagreen'
                        width: '50%'
                        height: '50%'
                    input
                        type: 'file'
                        # "load dictionary list"

                div
                    style:
                        display: 'flex'
                        background: 'grey'
                        height: 100
                        width: 40
                        flexDirection: 'column'
                    for idx in [0 .. 40]
                        p
                            key: "idex#{idx}"
                            style:
                                fontSize: 8
                                margin: 0
                            'hello'
                div
                    style:
                        display: 'flex'
                        width: 100
                        height: 100
                        background: 'purple'
                    svg
                        width: '100%'
                        height: '100%'
                        rect
                            width: '49%'
                            height: '50%'
                            x: '2%'
                            y: '30%'
                            fill: 'lightgreen'
                button
                    style:
                        background: 'magenta'
                    "maven"
            div
                style:
                    display: 'flex'
                div
                    style:
                        display: 'flex'
                        width: 100
                        height: 100
                        background: 'red'
                select_file_load()
                button
                    style:
                        background: 'green'
                        cursor: 'pointer'
                    "browse library"
                button
                    style:
                        background: 'grey'
                        cursor: 'pointer'
                    "load dictionary"
                button
                    style:
                        background: 'grey'
                        cursor: 'pointer'
                    "select algo"
                browse_pane @props, @state
            div
                style:
                    display: 'flex'
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
