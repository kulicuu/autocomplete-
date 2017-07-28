dz = ({ dispatch, desire_id }) ->
    dispatch
        type: 'sync__desire__kill'
        payload: { desire_id }

arq = {}

arq['primus:init_all_the_primus'] = ({ cs, State, dispatch, desire }) ->

    brujo__primus = State.get('brujo__primus')
    brujo__primus.on 'connection', (spark) ->
        dispatch
            type: 'brujo:primus:spark'
            payload: { spark }
        spark_id = spark.id
        spark.on 'data', (data) ->
            dispatch
                type: 'brujo:spark:data'
                payload: { spark_id, data }


    proto__primus = State.get 'proto__primus'
    proto__primus.on 'connection', (spark) ->

        headers = spark.headers

        primus_req = headers['primus::req::backup']

        { cookies, signedCookies, session } = primus_req

        token = signedCookies['connect.sid']

        session_metadata =
            signedCookies: signedCookies # survives browser refresh, set by connect-redis etc
            cookies: cookies # also survives browser refresh, 'caracal' set by us as a test
            session: session # does not survive browser refresh
            token: token # connect.sid

        dispatch
            type: 'proto:primus:spark'
            payload: { spark, session_metadata }


        spark_id = spark.id
        spark.on 'data', (data) ->

            { session, cookies, signedCookies } = spark.headers['primus::req::backup']
            token = signedCookies['connect.sid']
            session_metadata = { session, cookies, signedCookies, token }

            dispatch
                type: 'proto:spark:data'
                payload: { spark_id, data, session_metadata, token }

        spark.on 'end', ->
c color.white("Implement spark ending stuff.", on)
