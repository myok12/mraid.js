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
            #alert "loadingAd"
            #@_iframe.addEventListener "load", fn = (e) =>
            @_placeAd()
            #cb(null, e)
            #    @_iframe.removeEventListener "load", fn, false
            #, false

            #@_iframe.addEventListener "error", errFn = (e) ->
            #    cb(e, null)
            #    @removeEventListener "error", errFn, false
            #, false

            console.log @url
            @_iframe.src = @url
            console.log @_iframe

        _createIframe: ->
            @_iframe = d.createElement("iframe")

        _placeAd: ->
            alert "placingAd"
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
