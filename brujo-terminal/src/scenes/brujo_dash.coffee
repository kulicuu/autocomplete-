





data_structs_list = [
    "BK-tree"
    "prefix-tree"
]


pane_0 = (props, state, setState) ->
    div
        style:
            # position: 'absolute'
            backgroundColor: 'lightgreen'
            display: 'flex'
            # top: 4 + '%'
            # left: 4 + '%'
            width: '100%'
            height: '100%'
            # marginRight: 10

        div
            style:
                display: 'flex'
                flexDirection: 'column'
                paddingLeft: 6 + '%'
            h6 null, "select data source"
            select
                style:
                    color: 'blue'
                _.map props.raw_dctns_list, (dctn, idx) ->
                    option
                        value: dctn.filename
                        dctn.filename
            div
                style:
                    height: '100%'
                    width: '100%'
                    # paddingTop: 6 + '%'
                    marginTop: 6 + '%'
                    paddingLeft: 6 + '%'
                    backgroundColor: 'grey'
                h6 null, "browse data source raw"


        div
            style:
                display: 'flex'
                flexDirection: 'column'
                paddingLeft: 6 + '%'
            h6 null, "select data structure"
            select
                style:
                    color: 'red'
                _.map data_structs_list, (item, idx) ->
                    option
                        value: item
                        item
            div
                style:
                    display: 'flex'
                    marginTop: 10 + '%'
                    backgroundColor: 'lightblue'
                h6 null, "status:"

        div
            style:
                display: 'flex'
                flexDirection: 'column'
                backgroundColor: 'ivory'
                width: 20 + '%'
                marginLeft: 4 + '%'

            h6 null, 'search entry'
            input
                type: 'text'
                placeholder: 'search text'
                onChange: (e) =>
                    c e.currentTarget.value
            div
                style:
                    display: 'flex'
                    flexDirection: 'column'
                    backgroundColor: 'orange'
                p null, 'hello'















comp = rr

    getInitialState: ->
        dctn_selected: 'null'
        algo_selected: 'null'

    componentWillMount: ->
        @props.get_raw_dctns_list()

    render: ->
        c @props
        div
            style:
                display: 'flex'
                backgroundColor: 'lightsteelblue'
                height: '100%'
                width: '100%'

            if @props['get_dctns_list_state'] is 'received_it'
                # h1 null, 'received_it'
                pane_0 @props, @state, @setState.bind(@)












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
