###
# @authors Ohad Kravchick & Trevor Landau
###

do (root = window, d = window.document) ->
    "use strict"

    class AdService

        ###
        # @method _loadServices
        # @desc appends services to the url
        # @param {String} url
        # @param {Object} services
        # 
        # @return {String} - a new version of the ad url
        ###
        _loadServices: (url, services) ->
            {
                geo
            } = services

            # Add a param to the query string
            addParam = (key, val) ->
                queryRgx = new RegExp("^([?&])#{key}=.*?(&|$)", "i")

                if url.match(queryRgx)
                    url = url.replace(queryRgx, "$1#{key}=#{val}$2")
                else
                    sep = if url.indexOf("?") != -1 then "&" else "?"
                    url += "#{sep}#{key}=#{val}"
                    
            # Sets up each service onto the url of the ad
            configs =
                geo: ->
                    services.geo = false if geo != true
                    if geo then addParam("geo", "true")
                    
            for key of services
                unless config = configs[key] then throw new Error("No service named `#{key}`")
                config()

            return url

        loadAd: (el, url, services, cb) ->
            domain = url.split("?")[0]
            url = @_loadServices(url, services)
            ad = new Ad(domain, url, el, services)
            ad.loadAd(cb)

    class Ad
        constructor: (@domain, @url, el, @services) ->
            console.log arguments
            @_createIframe()
            @el = d.querySelector(el)
            unless @el then throw new Error "Element `#{el}` not found"

        loadAd: (cb, resp) ->
            @_on (data) ->
                cb(data)
            , resp

            @_iframe.src = @url
            @_placeAd()
            @setUpGeo()

        setUpGeo: ->
            geoLocation = window.navigator.geolocation
            if geoLocation
                @_on (data) ->
                    if data.type == "geoRequest"
                        if !@services.geo
                            @_post
                                type: "geoResponse",
                                data:
                                    err: "Location preferance not setup"
                        else
                            window.navigator.geolocation.getCurrentPosition (pos) =>
                                @_post
                                    type: "geoResponse"
                                    data:
                                        longitude: pos.coords.longitude
                                        latitude: pos.coords.latitude
                            , (err) =>
                                @_post
                                    type: "geoResponse"
                                    data:
                                        err: "Unable to get location"

        _createIframe: ->
            @_iframe = d.createElement("iframe")

        _placeAd: ->
            @el.appendChild(@_iframe)

        ###
        # @method _on
        # @param {Function} cb
        # @param {Mixed} resp - Allows immediate response to the origin 
        ###
        _on: (cb, resp) ->
            root.addEventListener "message", (e) =>
                if e.origin != @adDomain then return
                cb(e.data)
                if resp then e.source.postMessage(resp, e.origin)
            , false

        # Post a message to the ad
        _post: (msg) ->
            console.log @domain
            @_iframe.contentWindow.postMessage(msg, @domain)

    root.adService = new AdService()
