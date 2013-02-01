###
# @authors Ohad Kravchick & Trevor Landau
###

do (root = window, d = window.document) ->
    "use strict"

    class Ad
        constructor: (@url, el) ->
            @_createIframe()
            @el = d.querySelector(el)
            unless @el then throw new Error "Element `#{el}` not found"
        
        loadAd: (cb, resp) ->
            @on (data) =>
                cb(data)
            , resp

            @_iframe.src = @url
            @_placeAd()

        _createIframe: ->
            @_iframe = d.createElement("iframe")

        _placeAd: ->
            @el.appendChild(@_iframe)

        # Listen to messages from the ad
        on: (cb, resp) ->
            root.addEventListener "message", (e) =>
                if e.origin != @url then return
                cb(e.data)
                if resp then e.source.postMessage(resp, e.origin)
            , false

        # Post a message to the ad
        post: (msg) ->
            window.FF = @_iframe
            @_iframe.contentWindow.postMessage(msg, "http://localhost:8001")

    root.Ad = Ad
