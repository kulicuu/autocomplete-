



brujo_primus = new Primus(brujo_server, brujo_arq.opts)



brujo_server.listen brujo_arq.port, ->
    c 'server on'
