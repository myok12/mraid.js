###
# @authors Ohad Kravchick & Trevor Landau
###

do (root = window, parent = window.parent) ->
    "use strict"

    class AdContainer
        constructor: () ->

        _getParam: (paramName) ->
            params = window.location.search.slice(1).slice(0, -1).split("&")

            for param in params
                kvArr = param.split("=")
                if kvArr[0] == paramName
                    return kvArr[1]

        hasGeo: () ->
            @_getParam("geo")

        getGeoLocation: (cb) ->
            @_on (resp) ->
                if resp.type == "geoResponse"
                    cb(resp.data)
            @_post type: "geoRequest"

        ###
        # @method _on
        # @param {Function} cb
        # @param {Mixed} resp - Allows immediate response to the origin 
        ###
        _on: (cb, resp) ->
            root.addEventListener "message", (e) =>
                cb(e.data)
                if resp then e.source.postMessage(resp, e.origin)
            , false

        # Post a message to parent
        _post: (msg) ->
            parent.postMessage(msg, "*")

    root.adContainer = new AdContainer()
