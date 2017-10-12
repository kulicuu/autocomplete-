

# TODO: make a custom select element, the default is not
# so customisable


comp = rr


    getInitialState: ->
        {}


    render: ->
        div
            style: styles.jobs_browser()
            _.map @props.jobs, (job, client_ref) =>
                { tree_id } = job
                div
                    key: "job:#{client_ref}"
                    style:
                        display: 'flex'
                        justifyContent: 'space-around'
                    span
                        style:
                            fontSize: .01 * wh
                            color: 'darkslategrey'
                            fontFamily: 'sans'
                        job.job_type
                    if parseInt(job.perc_count) < 100
                        span
                            style:
                                fontSize: .01 * wh
                                color: 'darkslategrey'
                                fontFamily: 'sans'
                            job.perc_count + " % "
                    else
                        div
                            style:
                                display: 'flex'
                                justifyContent: 'space-around'
                            div
                                style:
                                    marginLeft: .004 * ww
                                    marginRight: .004 * ww
                                span
                                    style:
                                        fontFamily: 'sans'
                                        color: 'chartreuse'
                                    'DONE'
                            div
                                style:
                                    marginLeft: .004 * ww
                                button
                                    style:
                                        fontFamily: 'sans'
                                        fontSize: .01 * wh
                                        color: 'turquoise'
                                    onClick: do (tree_id) =>
                                        =>
                                            @props.radar_graph { tree_id }
                                    "RADAR"



map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    radar_graph: ({ tree_id }) ->
        dispatch
            type: 'radar_graph'
            payload: { tree_id }


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
