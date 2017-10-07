


window.styles = {}





styles.dash_button_002 =
    display: 'flex'
    cursor: 'pointer'
    minWidth: '10%'
    minHeight: '100%'
    alignItems: 'center'
    justifyContent: 'center'
    borderRadius: '20%'
    margin: '1%'
    backgroundColor: 'blanchedalmond'

# styles.dash_button_003 = fp.assign styles.dash_button_002,
#     backgroundColor: 'blanchedalmond'

styles.dash_button_002_mouseover = fp.assign styles.dash_button_002,
    backgroundColor: 'lightgreen'

styles.dash_button_text_002 = ->
    fontFamily: 'sans'
    fontSize: .03 * wh
    color: 'darkslategrey'
    alignText: 'center'
    fontWeight: 'normal'

styles.dash_button_text_002_mouseover = ->
    fontFamily: 'sans'
    fontSize: .03 * wh
    color: 'white'
    alignText: 'center'
    fontWeight: 'bold'



styles.dash_button =
    display: 'flex'
    cursor: 'pointer'
    minWidth: '10%'
    minHeight: '100%'
    alignItems: 'center'
    justifyContent: 'center'
    borderRadius: '20%'
    margin: '1%'

styles.dash_button_text = ({ ww, wh }) ->
    fontFamily: 'sans'
    fontSize: .02 * wh
    color: 'grey'
    alignText: 'center'
