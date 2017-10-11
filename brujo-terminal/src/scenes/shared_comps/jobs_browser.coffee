

# TODO: make a custom select element, the default is not
# so customisable


comp = rr


    getInitialState: ->
        {}


    render: ->
        div
            style: styles.jobs_browser()
            div
                style:
                    display: 'flex'
                    flexDirection: 'row'
                    justifyContent: 'space-around'
                span
                    style:
                        fontSize: .012 * wh
                    "job_type"
                span
                    style:
                        fontSize: .012 * wh
                    "% complete"

            _.map @props.jobs, (job, client_ref) =>
                div
                    key: "job:#{client_ref}"
                    style:
                        display: 'flex'
                        justifyContent: 'space-around'
                    span
                        style:
                            minWidth: '40%'
                        job.job_type
                    span
                        style:
                            minWidth: '40%'
                        job.perc_count



map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    {}


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
