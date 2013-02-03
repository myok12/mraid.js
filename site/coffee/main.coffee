$ ->
    output = $("#coords")

    if !Modernizr.geolocation
        output.html "Sorry, but your browser doesn't support geolocation"
    else
        console.assert navigator.geolocation

        geoFailed = ->
            output.html "Please enable location services"

        geoSuccess = (geopos) ->
            lat = geopos.coords.latitude
            lng = geopos.coords.longitude
            output.html "You are in (#{lat}, #{lng})"
        navigator.geolocation.getCurrentPosition geoSuccess, geoFailed


    adUrl = "http://localhost:8001"
    window.adService.loadAd "#ad", adUrl, {geo: true}, ->
        console.log "ad is loaded"
