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
            ###
            latlng = new google.maps.LatLng(lat, lng)
            geocoder = new google.maps.Geocoder()
            geocoder.geocode {'latLng': latlng}, (results, status) ->
                console.log(results)
                if status == google.maps.GeocoderStatus.OK
                    if results[1]
                        #formatted address
                        alert(results[0].formatted_address)
                        #find country name
                        for addressComponent in results[0].address_components.length
                            for type in addressComponent
                                #there are different types that might hold a city admin_area_lvl_1 usually does in come cases looking for sublocality type will be more appropriate
                                if type == "administrative_area_level_1"
                                    #this is the object you are looking for
                                    city = addressComponent
                                    break
                        #city data
                        alert city.short_name + " " + city.long_name
            ###
            output.html "You are in (#{lat}, #{lng})"
        navigator.geolocation.getCurrentPosition geoSuccess, geoFailed


    ad = new window.Ad("http://localhost:8001", "#ad")
    ad.loadAd ->
        console.log "ad is loaded"
