###
# @authors Ohad Kravchick & Trevor Landau
###

do (root = window, d = window.document) ->
    "use strict"

    class AdService
        constructor: ->
        _getLastPos: (cb) =>
            navigator.geolocation.getCurrentPosition (pos) =>
                cb({longitude: pos.coords.longitude, latitude: pos.coords.latitude})
        loadAdIntoEl: (el, {height, width, geo}, cb) =>
            adDomain = "http://localhost:8001"

            geo = false if geo != true
            if geo
                adUrl = "http://localhost:8001?geo=true"
            else
                adUrl = "http://localhost:8001?geo=false"

            ad = new Ad(adDomain, adUrl, el, {geo})
            ad.loadAd =>
                cb()

    class Ad
        constructor: (@adDomain, @url, el, @caps) ->
            @_createIframe()
            @el = d.querySelector(el)
            unless @el then throw new Error "Element `#{el}` not found"


        loadAd: (cb, resp) ->
            @_on (data) =>
                cb(data)
            , resp

            @_iframe.src = @url
            @_placeAd()
            @setUpGeo()

        setUpGeo: =>
            @_on (data) =>
                if data.type == "geoRequest"
                    if !@caps.geo
                        @_post { type: "geoResponse", data: {err: "Location is disallowed"}}
                    else
                        adService._getLastPos (pos) =>
                            @_post { type: "geoResponse", data: {pos: pos}}


        _createIframe: =>
            @_iframe = d.createElement("iframe")

        _placeAd: =>
            @el.appendChild(@_iframe)

        # Listen to messages from the ad
        _on: (cb, resp) ->
            root.addEventListener "message", (e) =>
                if e.origin != @adDomain then return
                cb(e.data)
                if resp then e.source.postMessage(resp, e.origin)
            , false

        # Post a message to the ad
        _post: (msg) =>
            @_iframe.contentWindow.postMessage(msg, "http://localhost:8001")

    root.adService = new AdService()
