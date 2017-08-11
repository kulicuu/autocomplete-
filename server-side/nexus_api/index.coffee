








nexus_api = {}


nexus_api = _.assign nexus_api, require('./bktree_spellcheck_api/index.coffee').default
nexus_api = _.assign nexus_api, require('./prefix_lookup_api/index.coffee').default


keys_nexus_api = _.keys nexus_api

nexus_api_f = ({ type, payload }) ->

    if _.includes(keys_nexus_api, type)
        nexus_api[type] { type, payload }
    else
        c "No-op in nexus_api."
