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
        
        loadAd: (cb) ->
            @on "load", =>
                @_placeAd()
                cb()

            @_iframe.src = @url

        _createIframe: ->
            @_iframe = d.createElement("iframe")

        _placeAd: ->
            @el.appendChild(@_iframe)

        # Listen to messages from the ad
        on: (event, cb, resp) ->
            root.addEventListener msg, (e) =>
                if e.origin != @url then return
                cb(e)
                e.source.postMessage(resp, e.origin)
            , false

        # Post a message to the ad
        post: (msg) ->
            root.postMessage(msg, @url)

    root.Ad = Ad
