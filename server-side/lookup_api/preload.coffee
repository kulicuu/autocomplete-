

fs = require 'fs'


break_ties = ({ candides }) ->
    # for now will just return the first,
    # but later can implement the logic for lexicographic order
    candides[0]


map_prefix_to_match = ({ dictionary, prefix }) ->
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


# At some point there will be multiple dictionaries, but for now just the one.

load_func = ->

    blob_1 = fs.readFileSync '../dictionaries/d1.txt', 'utf8'
    d1 = blob_1.split '\n'
    d1 = _.map d1, (word, idx) ->
        word.toLowerCase()


    tree =
        chd_nodes: {}
        prefix: ''


    for word, idx in d1
        cursor = tree
        prefix = ''
        unless word.length < 1
            for char, jdx in word
                prefix+= char
                if not _.includes(_.keys(cursor.chd_nodes), char)
                    cursor.chd_nodes[char] =
                        match_word: map_prefix_to_match({ prefix, dictionary: d1 })
                        prefix: prefix
                        chd_nodes: {}
                cursor = cursor.chd_nodes[char]

    { tree }



exports.default = load_func
