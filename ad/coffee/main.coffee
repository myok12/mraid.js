$ ->
    output = $("#coords")
    adContainer.getGeoLocation (data) ->
        pos = data.pos
        if data.err
            output.html("Cannot use geo")
        else
            output.html("User is at: (#{pos.longitude}, #{pos.latitude})")
