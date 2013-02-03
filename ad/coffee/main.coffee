$ ->
    output = $("#coords")
    adContainer.getGeoLocation (data) ->
        if data
            if data.err
                output.html("Cannot use geo")
            else
                output.html("User is at: (#{data.longitude}, #{data.latitude})")
        else
            output.html("No data passed")
