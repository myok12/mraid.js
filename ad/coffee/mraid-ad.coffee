###
# @authors Ohad Kravchick & Trevor Landau
###

do (root = window, parent = window.parent) ->
    "use strict"

    class Ad
        constructor: () ->

        # Listen to messages from parent
        on: (cb, resp) ->
            root.addEventListener "message", (e) =>
                cb(e.data)
                if resp then e.source.postMessage(resp, e.origin)
            , false

        # Post a message to parent
        post: (msg) ->
            parent.postMessage(msg, "*")

    root.Ad = Ad
