


window.styles = {}


styles.jobs_browser = ->
    margin: .008 * ww
    display: 'flex'
    flexDirection: 'column'
    backgroundColor: 'lightcyan'
    fontSize: .012 * wh


styles.dctn_scroll_item = ->
    fontSize: .012 * wh
    lineHeight: .00036 * wh
    color: 'grey'

styles.dctn_word_scroll = ->
    overflow: 'auto'
    width: '80%'
    height: '100%'


styles.dctn_browser = ->
    display: 'flex'
    flexDirection: 'column'
    backgroundColor: 'lightsteelblue'
    minHeight: .7 * wh
    minWidth: .12 * ww
    maxHeight: .7 * wh
    maxWidth: .12 * ww
    alignItems: 'center'
    margin: .02 * ww
    # justifyContent: 'center'


styles.select = ->
    minHeight: .04 * wh
    maxHeight: .04 * wh
    fontFamily: 'sans'
    fontSize: .012 * wh
    color: 'grey'



styles.dash_button_002 =
    display: 'flex'
    cursor: 'pointer'
    minWidth: '10%'
    minHeight: '100%'
    alignItems: 'center'
    justifyContent: 'center'
    # borderRadius: '20%'
    margin: '1%'
    backgroundColor: 'blanchedalmond'

# styles.dash_button_003 = fp.assign styles.dash_button_002,
#     backgroundColor: 'blanchedalmond'

styles.click_white = (time) ->
    backgroundColor: "hsl(#{time % 360}, #{time % 100}%, #{(1000 - time)/10}%)"
    color: 'snow'


styles.dash_button_002_mouseover = fp.assign styles.dash_button_002,
    backgroundColor: 'lightgreen'

styles.dash_button_text_002 = ->
    userSelect: 'none'
    fontFamily: 'sans'
    fontSize: .016 * wh
    color: 'darkslategrey'
    alignText: 'center'
    fontWeight: 'normal'

styles.dash_button_text_002_mouseover = ->
    userSelect: 'none'
    fontFamily: 'sans'
    fontSize: .016 * wh
    color: 'white'
    alignText: 'center'
    fontWeight: 'bold'


styles.nav_bar = ->
    display: 'flex'
    alignItems: 'center'
    justifyContent: 'center'
    backgroundColor: 'gainsboro'
    width: '100%'
    height: .024 * wh


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
