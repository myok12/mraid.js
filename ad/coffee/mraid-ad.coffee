###
# @authors Ohad Kravchick & Trevor Landau
###

do (root = window, parent = window.parent) ->
    "use strict"

    class AdContainer
        constructor: () ->

        _getParam: (paramName) ->
            search = window.location.search
            queryArr = search.split("?")
            query = queryArr[queryArr.length-1]
            paramsArr = query.split("&")
            for param in paramsArr
                kvArr = param.split("=")
                if kvArr[0] == paramName
                    return kvArr[1]

        hasGeo: () ->
            @_getParam("geo") == "true"

        # Listen to messages from parent
        on: (cb, resp) ->
            root.addEventListener "message", (e) =>
                cb(e.data)
                if resp then e.source.postMessage(resp, e.origin)
            , false

        # Post a message to parent
        post: (msg) ->
            parent.postMessage(msg, "*")

    root.adContainer = new AdContainer()
