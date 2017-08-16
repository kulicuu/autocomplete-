

# private
lookup_node_at_prefix = ({ prefix, prefix_tree }) ->
    cursor = prefix_tree
    prefix_rayy = prefix.split ''
    c prefix, color.blue('prefix', on)
    for char in prefix_rayy
        cursor = cursor.chd_nodes[char]
        if cursor is undefined
            return 'Not found.'
    _.omit cursor, 'chd_nodes'


# public constructor for api
api_load = ({ prefix_tree, bktree }) ->
    api = {}

    # api.browse_dictionary = ({ dictionary_id, rayy_range }) ->

    # api.lookup_bktree = ({ word }) ->

    # public function on api
    api.lookup_prefix_000 = ({ prefix, prefix_tree }) ->
        lookup_node_at_prefix
            prefix: prefix
            prefix_tree: prefix_tree


    ({ prefix, opts }) ->
        if _.includes(_.keys(opts), 'lookup_type')
            api[opts.lookup_type] { prefix, prefix_tree }


# there will be more than one dictionary but for now just this one tree
{ tree: prefix_tree } = require('./preload.coffee').default()

{ bktree } = require('./burkhard-keller_tree_300.coffee').default()

exports.default = api_load { prefix_tree }
