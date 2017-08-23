



table_row =
    display: 'flex'
    flexDirection: 'row'
    flexWrap: 'no-wrap'
    width: '100%'
    paddingLeft: 15
    paddingRight: 15


header =
    backgroundColor: '#FFEEDB'
    fontWeight: 'bold'
    paddingTop: 6
    paddingBottom: 6

table_row_header = _.assign table_row, header



column =
    flexGrow: 0
    flexShrink: 0
    verticalAlign: 'top'

index =
    textAlign: 'center'

column_index = _.assign column, index


wrapper =
    display: 'flex'
    flexDirection: 'row'

attributes =
    flexGrow: 1

wrapper_attributes = _.assign wrapper, attributes





pane_0_svg_000 = (props, state, setState) ->

    div
        style:
            position: 'absolute'
            top: '20%'
            left: '20%'
        svg
            x: '10%'
            y: '10%'
            width: '60%'
            height: '80%'
            background: 'white'
            rect
                x: '0%'
                y: '0%'
                width: '100%'
                height: '100%'
                fill: 'magenta'

            rect
                x: '10%'
                y: '10%'
                width: '80%'
                height: '80%'
                fill: 'chartreuse'




pane_0 = (props, state, setState) ->
    div
        style:
            width: '40%'
            height: '40%'
        div
            style: table_row_header
            div
                style: column_index
                '#'
            div
                style: wrapper_attributes
                div
                    style: _.assign column,
                        paddingLeft: 6
                    "something"







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
                pane_0_svg_000()












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
