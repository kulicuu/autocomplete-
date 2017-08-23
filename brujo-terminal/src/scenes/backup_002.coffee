

# NOTE The UI support for features:
# 1.  loading dictionary file from disc, caching raw in redis as a string, in the
# main meta hash of that.


# NOTE to reduce the work for the moment we'll just read in all the dictionaries as lists
# on the server side on startup.  then these can be applied to various parser/data-strucutre-factories
# and these can be browsed and tested


list_of_components =
    'raw dictionary list': 'aeu'
    'browse dictionary list pane': 'sth'






raw_dctn_pane = (props, state, setState) ->
    div
        style:
            display: 'flex'
            flexDirection: 'column'
            alignItems: 'start'
            justifyContent: 'start'
            background: 'palegreen'
            width: '8%'
            height: '60%'
        h4
            style:
                color: 'orange'
            "raw dictionaries"
        div
            style:
                marginTop: 10
            for v, idx in props.raw_dctns_list
                do (v) =>
                    p
                        onClick: (e) =>
                            c v
                            setState
                                dctn_selected: v.filename
                            props.browse_dctn v.filename
                        style:
                            color: if v.filename is state.dctn_selected
                                'white'
                            else
                                'black'
                            cursor: 'pointer'
                            fontSize: 10
                            margin: 0
                            marginTop: 5
                            marginLeft: 10
                        key: "dctns_filename#{idx}"
                        v.filename.split('.')[0]



browse_raw = (props, state) ->
    div
        style:
            background: 'chartreuse'
            minWidth: '10%'
            scroll: 'auto'
        for word, idx in props.dctn_blob.split('\n')
            p
                style:
                    margin: 4
                    fontSize: 8
                key: "word#{idx}"
                "   #{word}"






apply_algo_panel = (props, state, setState) ->
    c state.dctn_selected
    div
        style:
            background: 'magenta'
        h4
            style:
                color: 'blue'
            "Apply algo:"
        div null,
            button
                onClick: ->
                    setState
                        algo_selected: 'burkhard-keller_tree'
                style:
                    cursor: 'pointer'
                    background: if state.algo_selected is 'bktree' then 'white' else 'darkgrey'
                "burkhard-keller tree"
        div null,
            button
                onClick: ->
                    setState
                        algo_selected: 'char-tree-autocomplete'
                style:
                    cursor: 'pointer'
                    background: if state.algo_selected is 'char-tree-autocomplete' then 'white' else 'darkgrey'
                "char-tree autocomplete"
        h4
            style:
                color: 'blue'
            "to #{state.dctn_selected} "
        button
            onClick: ->
                props.apply_parse_build_data_structure(state.dctn_selected, state.algo_selected)
            style:
                cursor: 'pointer'
                backgroundColor: if ( ( state.dctn_selected isnt 'null') and (state.algo_selected isnt 'null') ) then 'white' else 'red'
            "Go"



comp = rr

    getInitialState: ->
        dctn_selected: 'null'
        algo_selected: 'null'



    componentWillMount: ->
        # c 'okay'
        @props.get_raw_dctns_list()

    render: ->
        div
            style:
                display: 'flex'
                # flexDirection: 'column'
                # alignItems: 'center'
                # justifyContent: 'center'
                backgroundColor: 'lightsteelblue'
                height: '100%'
                width: '100%'
            raw_dctn_pane @props, @state, @setState.bind(@)

            # c @props
            browse_raw @props, @state
            # div null,
            #     for word, idx in @props.dctn_blob.split('\n')
            #         p
            #             style:
            #                 margin: 4
            #                 fontSize: 8
            #             key: "word#{idx}"
            #             "   #{word}"
            # "aeosunth"


            apply_algo_panel @props, @state, @setState.bind(@)










map_state_to_props = (state) ->
    state.get('lookup').toJS()

map_dispatch_to_props = (dispatch) ->

    apply_parse_build_data_structure: (filename, algo_name) ->
        dispatch
            type: 'apply_parse_build_data_structure'
            payload:
                filename: filename
                algo_name: algo_name

    browse_dctn: (filename) ->
        dispatch
            type: 'browse_dctn'
            payload:
                filename: filename

    get_raw_dctns_list: ->
        dispatch
            type: 'get_raw_dctns_list'


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
