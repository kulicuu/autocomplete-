

# TODO: make a custom select element, the default is not
# so customisable


comp = rr

    scroll_func: ->
        @setState
            upper_bound: @state.upper_bound + 40
            lower_bound: @state.lower_bound + 40
        @props.browse_dctn
            filename: @state.data_src_select
            upper_bound: @state.upper_bound
            lower_bound: @state.lower_bound


    getInitialState: ->
        data_src_select: 'null'
        upper_bound: 100
        lower_bound: 10

    componentWillMount: ->
        @props.get_raw_dctns_list()

    render: ->
        div
            style: styles.dctn_browser()
            select
                style: styles.select()
                onChange: (e) =>
                    @setState
                        data_src_select: e.currentTarget.value
                    @props.browse_dctn
                        filename: e.currentTarget.value
                        upper_bound: @state.upper_bound
                        lower_bound: @state.lower_bound
                option
                    disabled: true
                    selected: true
                    value: true
                    "select data source"
                _.map @props.raw_dctns_list, (dctn, idx) ->
                    option
                        key: "option1:#{idx}"
                        value: dctn.filename
                        dctn.filename
            div
                style: styles.dctn_word_scroll()
                onScroll: (e) =>
                    # TODO: improve scroll handling logic
                    if (e.target.scrollTop / e.target.scrollHeight) > .2
                        @scroll_func()
                _.map @props['browse_rayy'], (word, k) ->
                    p
                        key: "word_item:#{k}"
                        style: styles.dctn_scroll_item()
                        word


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    get_raw_dctns_list: ->
        dispatch
            type: 'get_raw_dctns_list'

    browse_dctn: ({ filename, upper_bound, lower_bound }) ->
        dctn_name = filename
        # TODO replace this ducttape logic with a redis side approach
        # that lowers the upper bounds if the list is too small
        if dctn_name isnt 'd1.txt'
            upper_bound = 50
        dispatch
            type: 'browse_dctn'
            payload: { dctn_name, upper_bound, lower_bound }


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
