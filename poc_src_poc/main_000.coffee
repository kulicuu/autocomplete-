require './globals.coffee'



lookup_node_at_prefix = ({ prefix, tree }) ->
    cursor = tree
    prefix_rayy = prefix.split ''
    for char in prefix_rayy
        cursor = cursor.chd_nodes[char]
        # c cursor is undefined
        if cursor is undefined
            return 'Not found.'
    return cursor


break_ties = ({ candides }) ->
    # for now will just return the first,
    # but later can implement the logic for lexicographic order
    candides[0]


map_prefix_to_word = ({ dictionary, prefix }) ->
    # c color.green prefix
    # c dictionary
    candides = []
    for word in dictionary
        if word.indexOf(prefix) is 0
            candides.push word
    if candides.length > 1
        return break_ties { candides }
    else
        return candides.pop()


blob = fs.readFileSync 'string_dictionary.txt', 'utf8'

the_dictionary = blob.split '\n'
the_dictionary = _.map the_dictionary, (word, idx) ->
    word.toLowerCase()
c the_dictionary

tree =
    chd_nodes: {}
    prefix: ''

for word, idx in the_dictionary
    cursor = tree
    prefix = ''
    unless word.length < 1
        for char, jdx in word
            prefix+= char
            if not _.includes(_.keys(cursor.chd_nodes), char)
                cursor.chd_nodes[char] =
                    match_word: map_prefix_to_word({ prefix, dictionary: the_dictionary })
                    prefix: prefix
                    chd_nodes: {}
            cursor = cursor.chd_nodes[char]
c tree

c color.green "\n \n So now everything is built. \n \n"


# test:
prefix_000 = 'cece'

the_node = lookup_node_at_prefix
    prefix: prefix_000
    tree: tree

c the_node
