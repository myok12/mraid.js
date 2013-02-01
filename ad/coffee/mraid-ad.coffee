###
# @authors Ohad Kravchick & Trevor Landau
###

do (root = window, parent = window.parent) ->
    "use strict"

    class Ad
        constructor: () ->

        # Listen to messages from the ad
        on: (cb, resp) ->
            root.addEventListener "message", (e) =>
                if e.origin != @url then return
                cb(e.data)
                if resp then e.source.postMessage(resp, e.origin)
            , false

        # Post a message to the ad
        post: (msg) ->
            parent.postMessage(msg, "*")

    root.Ad = Ad
