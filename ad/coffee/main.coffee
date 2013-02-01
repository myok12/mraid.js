$ ->
    ad = new window.Ad
    ad.post { ohad: "stinks", dan: "is doing ads" }
    ad.on (data) ->
        console.log data
