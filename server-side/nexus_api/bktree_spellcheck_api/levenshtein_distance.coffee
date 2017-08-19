





# https://en.wikipedia.org/wiki/Levenshtein_distance




# recursive version
lev_d = ( s, len_s, t, len_t ) ->

    cost = null

    if len_s is 0 then return len_t
    if len_t is 0 then return len_s

    if s[len_s - 1] is t[len_t - 1]
        cost = 0
    else
        cost = 1

    Math.min (lev_d( s, len_s - 1, t, len_t ) + 1),
    (lev_d( s, len_s, t, len_t - 1) + 1),
    (lev_d(s, len_s - 1, t, len_t - 1) + cost)


lev_d_w = ( s, t ) ->
    len_s = s.length
    len_t = t.length
    lev_d s, len_s, t, len_t


exports.default = lev_d_w


# exports.test = ->
#
#     c = console.log.bind console
#
#     run_it = ({ s, t }) ->
#         len_s = s.length
#         len_t = t.length
#
#         x = lev_d s, len_s, t, len_t
#         c x
#
#     run_it
#         s: 'howdy'
#         t: 'howdo'



# another, non-recursive implementation
# not recursive version levenshtein distance
# unused
lev_del_nocurse = ({ s, t }) ->
    len_s = s.length
    len_t = t.length
    if len_s is 0 then return len_t
    if len_t is 0 then return len_s

    # d = [len_s + 1, len_t + 1]
    matrix = []
    for idx in [0 .. len_s]
        matrix[idx] = []
        for jdx in [0 .. len_t]
            matrix[idx][jdx] = 'void'

    for idx in [0 .. len_s]
        matrix[idx][0] = idx

    for jdx in [0 .. len_t]
        matrix[0][jdx] = jdx

    for idx in [1 .. len_s]
        for jdx in [1 .. len_t]
            match = null
            if s[idx - 1] is t[j - 1]
                match = 0
            else
                match = 1

            matrix[idx][jdx] = Math.min(Math.min(matrix[idx - 1][jdx] + 1, matrix[idx][jdx - 1] + 1), matrix[idx - 1][jdx - 1] + match)

    matrix[len_s][len_t]
