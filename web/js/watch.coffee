player = undefined

get_endpoint = "https://radmontage.herokuapp.com/get.php"

onYouTubeIframeAPIReady = ->
    player = new (YT.Player)('player',
        playerVars:
            controls: 0
            showinfo: 0

        events:
            'onReady': onPlayerReady
            'onStateChange': onPlayerStateChange)

onPlayerReady = () ->

onPlayerStateChange = () ->

playing = false

get_param_and_start = (func) ->
    param = window.location.search.split("?m=")
    if param.length > 0 && param[1].length > 0
        id = param[1]
        $.get(get_endpoint, {
                id: id
            },
            func,
            'json'
        )

if_zero_return_null = (i) ->
    if i == 0
        null
    else
        i

get_video_url = (videos, video_index) ->
    videos[3*video_index]

get_video_start = (videos, video_index) ->
    if_zero_return_null(videos[3*video_index + 1])


get_video_end = (videos, video_index) ->
    if_zero_return_null(videos[3*video_index + 2])

$ ->
    overlay = $('#overlay')
    overlay_i = 0
    video_index = 0


    clearOverlay = ->
        overlay.css 'background-image', ''
        overlay.css 'height', '92%'
        overlay_i = 0
        playing = true

    overlays = [
        ['', 'testCard', 150],
        ['contain', 'testCard2', 600],
        ['', 'testCard', 600],
    ]

    onPlayerStateChange = (event) ->
        if event.data == YT.PlayerState.PLAYING
            clearOverlay()

    showStaticOverlay = ->
        if !playing
            if overlay_i > overlays.length - 1
                overlay_i = 0
            i = overlay_i
            overlay.css 'height', '100%'
            overlay.css 'background-size', overlays[i][0]
            overlay.css 'background-image', "url('img/#{overlays[i][1]}.gif')"
            overlay_i += 1
            setTimeout(showStaticOverlay, overlays[i][2])

    get_param_and_start (videos) ->
        montage_name = videos[0]
        videos = videos.slice(1)
        click_movie_function = ->
            playing = false
            showStaticOverlay()
            player.loadVideoById
                videoId: get_video_url(videos, video_index)
                startSeconds: get_video_start(videos, video_index)
                endSeconds: get_video_start(videos, video_index)
                suggestedQuality: 'large'
            video_index += 1

        overlay[0].addEventListener 'click', click_movie_function, true
        click_movie_function()
