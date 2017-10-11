

# TODO: make a custom select element, the default is not
# so customisable


comp = rr


    getInitialState: ->
        {}


    render: ->
        div
            style: styles.jobs_browser()
            # div
            #     style:
            #         display: 'flex'
            #         flexDirection: 'row'
            #         justifyContent: 'space-around'
            #     span
            #         style:
            #             fontSize: .012 * wh
            #         "job_type"
            #     span
            #         style:
            #             fontSize: .012 * wh
            #         "% complete"

            _.map @props.jobs, (job, client_ref) =>
                div
                    key: "job:#{client_ref}"
                    style:
                        display: 'flex'
                        justifyContent: 'space-around'
                    span
                        style:
                            fontSize: .011 * wh
                            color: 'darkslategrey'
                            fontFamily: 'sans'
                        job.job_type
                    if parseInt(job.perc_count) < 100
                        span
                            style:
                                # minWidth: '40%'
                                fontSize: .011 * wh
                                color: 'darkslategrey'
                                fontFamily: 'sans'
                            job.perc_count + " % "
                    else
                        span
                            style:
                                fontFamily: 'sans'
                                color: 'chartreuse'
                            'DONE'



map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
