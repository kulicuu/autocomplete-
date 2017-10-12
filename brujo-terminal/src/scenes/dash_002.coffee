

nav_bar = rc require('./shared_comps/nav_bar.coffee').default
dctn_browser = rc require('./shared_comps/dctn_browser.coffee').default
text_entry_feedback = rc require('./shared_comps/text_entry_feedback.coffee').default

jobs_browser = rc require('./shared_comps/jobs_browser.coffee').default


job_in_progress = (jobs) ->
    _.reduce jobs, (acc, job, k) ->
        if parseInt(job.perc_count) < 100
            true
    , false


comp = rr
    render: ->
        is_busy = job_in_progress @props.jobs
        div null,
            nav_bar()
            div
                style:
                    display: 'flex'
                div
                    style:
                        display: 'flex'
                        flexDirection: 'column'
                    dctn_browser()
                    button
                        disabled: is_busy
                        style:
                            margin: .01 * ww
                            width: .04 * ww
                        onClick: =>
                            @props.prefix_tree_build_tree
                                dctn_selected: @props.dctn_selected
                        if is_busy
                            "busy building"
                        else
                            "build prefix tree"
                    jobs_browser()
                    if is_busy
                        button
                            style:
                                margin: .01 * ww
                                width: .04 * ww
                                backgroundColor: 'thistle'
                                color: 'snow'
                            onClick: =>
                                @props.cancel_job()
                            "cancel job"

                text_entry_feedback()


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->

    cancel_job: -> #TODO: identify the precise job to be canceled
        dispatch
            type: 'cancel_prefix_tree_job'
            payload: null

    prefix_tree_build_tree : ({ dctn_selected }) ->
        dispatch
            type: 'prefix_tree_build_tree'
            payload: { dctn_name: dctn_selected }


    search_prefix_tree : ({ prefix }) ->
        dispatch
            type: 'search_prefix_tree'
            payload:
                client_ref: 'placeholder'  # another client ref.
                tree_id: 'placeholder'   # will identify exactly which tree to search
                prefix: prefix

exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
