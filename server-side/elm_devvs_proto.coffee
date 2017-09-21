# copied/translated from https://github.com/knowthen/elm-beyond-basics



c = console.log.bind console
_ = require 'lodash'
color = require 'bash-color'




WebSocketServer = require('ws').Server
Rx = require 'rx'
dateFormat = require 'dateformat'


server = new WebSocketServer({ port: 5000 })

server.on 'connection', (ws) ->
    c "#{color.green('client connected!', on)}"
    pauser = new Rx.Subject()
    Rx.Observable
        .interval 1000
        .timeInterval()
        .map (x) -> new Date
        .map (now) -> dateFormat(now, "h:MM:ss TT")
        .pausible pauser
        .subscribe (time) ->
            if (ws.readyState is ws.OPEN)
                ws.send JSON.stringify({ time })
            else if (ws.readyState is ws.CLOSED)
                pauser.onNext false
    ws.on 'message', (message) ->
        if message is "start"
            pauser.onNext true
        else if message is "stop"
            pauser.onNext false
    ws.on 'close', ->
        c "#{color.blue('client disconnected!', on)}"
