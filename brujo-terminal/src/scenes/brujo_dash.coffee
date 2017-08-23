



comp = rr




    getInitialState: ->
        dctn_selected: 'null'
        algo_selected: 'null'

    componentWillMount: ->
        @props.get_raw_dctns_list()

    render: ->
        c @props['get_dctns_list_state']
        div
            style:
                display: 'flex'
                backgroundColor: 'lightsteelblue'
                height: '100%'
                width: '100%'

            if @props['get_dctns_list_state'] is 'received_it'
                h1 null, 'received_it'












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
