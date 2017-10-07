


window.styles = {}


styles.dctn_word_scroll = ->
    overflow: 'auto'


styles.dctn_browser = ->
    display: 'flex'
    flexDirection: 'column'
    backgroundColor: 'lightsteelblue'
    minHeight: .5 * wh
    minWidth: .12 * ww
    maxHeight: .5 * wh
    maxWidth: .12 * ww
    alignItems: 'center'
    margin: .02 * ww
    # justifyContent: 'center'


styles.select = ->
    minHeight: .04 * wh
    maxHeight: .04 * wh
    fontFamily: 'sans'
    fontSize: .02 * wh
    color: 'grey'



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


styles.nav_bar = ->
    display: 'flex'
    alignItems: 'center'
    justifyContent: 'center'
    backgroundColor: 'gainsboro'
    width: '100%'
    height: .06 * wh


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
