$ ->
    ad = new window.Ad
    ad.on (data) ->
        document.body.innerHTML = data
    ad.post { ohad: "stinks", dan: "is doing ads" }
