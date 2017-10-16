api = {}

# arq = assign arq, require('./side_effects/init.coffee').default


api = assign api, require('./effects/core.coffee').default


keys_api = keys api


effects_f = ({ store }) ->
    ({ state_js }) ->
        state = state_js
        for key_id, effect of state.lookup.effect
            if includes(keys_api, effect.type)
                api[effect.type] { effect , store }


exports.default = effects_f
