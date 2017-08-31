





data_structs_list = [
    "BK-tree"
    "prefix-tree"
]


pane_0 = (props, state, setState, scroll_func) ->

    if (state.data_struct_type_select isnt 'null') and (state.data_src_select isnt 'null')
        ready_to_build = true
    else
        ready_to_build = false
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
                onChange: (e) =>
                    setState
                        data_src_select: e.currentTarget.value
                    props.browse_dctn
                        filename: e.currentTarget.value
                        upper_bound: state.upper_bound
                        lower_bound: state.lower_bound
                option
                    disabled: true
                    selected: true
                    value: true
                    "select an option"
                _.map props.raw_dctns_list, (dctn, idx) ->
                    option
                        key: "option1:#{idx}"
                        value: dctn.filename
                        dctn.filename
            div
                onScroll: (e) =>
                    c e.target.scrollTop
                    c e.target.scrollHeight
                    if (e.target.scrollTop / e.target.scrollHeight) > .4
                        scroll_func()
                style:
                    height: '50%'
                    width: '100%'
                    # paddingTop: 6 + '%'
                    overflow: 'auto'

                    # scroll: 'auto'
                    marginTop: 6 + '%'
                    paddingLeft: 6 + '%'
                    backgroundColor: 'grey'
                h6 null, "browse data source raw"
                _.map props['browse_rayy'], (word, k) ->
                    p
                        key: "word_item#{k}"
                        style:
                            margin: '10%'
                            fontSize: '70%'
                            color: 'orange'
                        word

        div
            style:
                display: 'flex'
                flexDirection: 'column'
                paddingLeft: 6 + '%'
            h6 null, "select data structure"
            select
                style:
                    color: 'red'
                onChange: (e) =>
                    setState
                        data_struct_type_select: e.currentTarget.value

                option
                    disabled: true
                    selected: true
                    value: true
                    "select an option"
                _.map data_structs_list, (item, idx) ->
                    option
                        key: "option2:#{idx}"
                        value: item
                        item
            div
                style:
                    display: 'flex'
                    flexDirection: 'column'
                    marginTop: 10 + '%'
                    backgroundColor: 'lightblue'
                h6 null, "status:"
                button
                    style:
                        backgroundColor: 'yellow'
                        color: 'purple'
                    disabled: if ready_to_build then false else true
                    onClick: =>
                        # c 'go build', state
                        if ready_to_build
                            props.build_selection
                                data_src_select: state.data_src_select
                                data_struct_type_select: state.data_struct_type_select
                    "Build it"
                    # this call will trigger build and cache, bacause it assumes wasn't cached already



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
                    props.search_struct_001
                        query_expr: e.currentTarget.value
            div
                style:
                    margin: '2%'
                    display: 'flex'
                    flexDirection: 'column'
                    # backgroundColor: 'orange'

                _.map props.search_results, (candide, idx) ->
                    p
                        key: "search_results:#{idx}"
                        style:
                            margin: 0
                            color: 'chartreuse'
                            fontSize: '70%'
                        candide
                # p null, 'hello'















comp = rr

    scroll_func: ->
        @setState
            upper_bound: @state.upper_bound + 40
            lower_bound: @state.lower_bound + 40
        @props.browse_dctn
            filename: @state.data_src_select
            upper_bound: @state.upper_bound
            lower_bound: @state.lower_bound

    componentDidMount: ->

        # setInterval @scroll_func, 3000

    getInitialState: ->
        upper_bound: 50
        lower_bound: 10
        data_src_select: 'null'
        data_struct_type_select: 'null'

    componentWillMount: ->
        @props.get_raw_dctns_list()
        @props.get_initial_stati()

    render: ->
        # c @props
        div
            style:
                display: 'flex'
                backgroundColor: 'lightsteelblue'
                height: '100%'
                width: '100%'

            if @props['get_dctns_list_state'] is 'received_it'
                # h1 null, 'received_it'
                pane_0 @props, @state, @setState.bind(@), @scroll_func














map_state_to_props = (state) ->
    state.get('lookup').toJS()

map_dispatch_to_props = (dispatch) ->


    search_struct_001: ({ query_expr }) ->
        dispatch
            type: 'primus_hotwire'
            payload:
                type: 'search_struct_nodemem'
                payload:
                    query_expr: query_expr


    search_struct_000: ({ query_expr }) ->
        dispatch
            type: 'search_struct'
            payload:
                query_expr: query_expr

    build_selection: ({ data_struct_type_select, data_src_select })->
        dispatch
            type: 'build_selection'
            payload: { data_struct_type_select, data_src_select }


    get_initial_stati: ->
        dispatch
            type: 'get_initial_stati'



    browse_dctn: ({ filename, upper_bound, lower_bound }) ->
        dctn_name = filename
        dispatch
            type: 'browse_dctn'
            payload: { dctn_name, upper_bound, lower_bound }

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
