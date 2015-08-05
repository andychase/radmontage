player = undefined


onYouTubeIframeAPIReady = ->
    player = new (YT.Player)('player',
        playerVars:
            controls: 0
            showinfo: 0
        videoId: 'M7lc1UVf-VE'
        events:
            'onReady': onPlayerReady
            'onStateChange': onPlayerStateChange)
    return

onPlayerReady = () ->
    return

onPlayerStateChange = () ->
    return

playing = false

$ ->
    overlay = $('#overlay')
    overlay_i = 0

    clearOverlay = ->
        overlay.css 'background-image', ''
        overlay.css 'height', '92%'
        overlay_i = 0
        playing = true

    overlays = [
        ['',        'testCard', 150],
        ['contain', 'testCard2', 600],
        ['',        'testCard', 600],

    ]


    showStaticOverlay = ->
        if !playing
            if overlay_i > overlays.length-1
                overlay_i = 0
            i = overlay_i
            overlay.css 'height', '100%'
            overlay.css 'background-size', overlays[i][0]
            overlay.css 'background-image', "url('img/#{overlays[i][1]}.gif')"
            overlay_i += 1
            setTimeout(showStaticOverlay, overlays[i][2])

    onPlayerReady = (event) ->
        clearOverlay()
        event.target.playVideo()
        return

    onPlayerStateChange = (event) ->
        if event.data == YT.PlayerState.PLAYING
            clearOverlay()

    click_movie_function = ->
        playing = false
        showStaticOverlay()
        player.loadVideoById
            videoId: 'bHQqvYy5KYo'
            startSeconds: 5
            endSeconds: 7
            suggestedQuality: 'large'

    overlay[0].addEventListener 'click', click_movie_function, true
