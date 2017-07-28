

# private
lookup_node_at_prefix = ({ prefix, tree }) ->
    cursor = tree
    prefix_rayy = prefix.split ''
    c prefix
    for char in prefix_rayy
        cursor = cursor.chd_nodes[char]
        if cursor is undefined
            return 'Not found.'
    _.omit cursor, 'chd_nodes'


# public constructor for api
api_load = ({ tree }) ->
    api = {}

    # public function on api
    api.lookup_prefix_000 = ({ prefix}) ->
        lookup_node_at_prefix
            prefix: prefix
            tree: tree

    # api returned as a function
    ({ prefix, opts }) ->
        c arguments
        if _.includes(_.keys(opts), 'lookup_type')
            api[opts.lookup_type] { prefix, tree }  # returns a_node


# there will be more than one dictionary but for now just this one tree
{ tree } = require('./preload.coffee').default()


exports.default = api_load { tree }
