
# not so customizable class using version of dash button.
# doesn't take styles as args, just takes the dispatch msg, and button text


click_time = (counter, setState) ->
    setTimeout ->
        counter-= 10
        setState
            click_time: counter
        if counter > 0
            click_time(counter, setState)
        else
            setState
                click_time: null
                click_white: false
    , 10


comp = rr

    getInitialState : ->
        click_white : false
        hovering : false
        click_time : null

    render: ->
        div
            style:
                if @state.click_white is true
                    styles.click_white @state.click_time
                else
                    if @state.hovering is true
                        styles.dash_button_002_mouseover
                    else
                        styles.dash_button_002
            onMouseOver: =>
                @setState
                    hovering: true
            onMouseOut: =>
                @setState
                    hovering: false
            onClick: =>
                @setState
                    click_white: true
                click_time 1000, @setState.bind(@)
                @props.click_action @props.action_msg
            span
                style: if @state.hovering is true
                        styles.dash_button_text_002_mouseover()
                    else
                        styles.dash_button_text_002()
                @props.button_text


map_state_to_props = (state) ->
    state.get('lookup').toJS()


map_dispatch_to_props = (dispatch) ->
    click_action: (action_msg) ->
        dispatch
            type: action_msg
            payload: null


exports.default = connect(map_state_to_props, map_dispatch_to_props)(comp)
