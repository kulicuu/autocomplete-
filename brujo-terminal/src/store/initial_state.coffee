exports.default =

    lookup:

        view: "prefix_tree_view"

        tree_cursor: null

        jobs: Imm.Map({})

        search_results: []

        dctn_selected: null

        prefix_tree_match: null

        get_dctns_list_state: null

        effects : Imm.Map
            # "#{shortid()}":
            #     type: 'init_keyboard'
            #     payload: 'asnetuhnn'
            "#{shortid()}":
                type: 'init_primus'

        # chat_log: Imm.List([])
        match: ''
        raw_dctns_list: []
        dctn_blob: ''

        # username: 'placholder username'
