





# https://en.wikipedia.org/wiki/Levenshtein_distance


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


exports.test = ->

    c = console.log.bind console

    run_it = ({ s, t }) ->
        len_s = s.length
        len_t = t.length

        x = lev_d s, len_s, t, len_t
        c x

    run_it
        s: 'howdy'
        t: 'howdo'
