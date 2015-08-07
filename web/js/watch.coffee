videos = window.videos
player = undefined
iOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
ready = false
testCardImageBasePath = "https://d12gd74eaa9d1v.cloudfront.net/"

onYouTubeIframeAPIReady = ->
    player = new (YT.Player)('player',
        playerVars:
            controls: 0
            showinfo: 0
            iv_load_policy: 3

        events:
            onReady: () -> onPlayerReady()
            onStateChange: (e) -> onPlayerStateChange(e)
    )

onPlayerReady = () ->
    ready = true

onPlayerStateChange = () ->


if_zero_return_null = (i) ->
    if i == 0
        null
    else
        i

get_video_url = (videos, video_index) ->
    videos[3 * video_index]

get_video_start = (videos, video_index) ->
    if_zero_return_null(videos[3 * video_index + 1])


get_video_end = (videos, video_index) ->
    if_zero_return_null(videos[3 * video_index + 2])

$ ->
    instructions = $("#instructions")
    need_to_show_instructions = true
    overlay = $('#overlay')
    bgvid = $('#bgvid')
    overlay_i = 0
    video_index = 0
    playing = true

    if iOS
        bgvid.hide()
        overlay.addClass("ios")
        instructions.addClass("ios")
        overlay.html("<span>SKIP</span>")

    clearOverlay = ->
        if not iOS
            overlay.css 'background-image', ''
            overlay.css 'height', '80%'
            bgvid.hide()
            overlay_i = 0
            playing = true

    overlays = [
        [false, 'testCard', 150],
        [true, 'testCard', 900],
        [false, 'testCard', 600],
    ]

    showStaticOverlay = ->
        if !playing and not iOS
            if overlay_i > overlays.length - 1
                overlay_i = 0
            i = overlay_i
            overlay.css 'height', '100%'
            overlay.css 'background-image', "url('#{testCardImageBasePath}#{overlays[i][1]}.gif')"
            if overlays[i][0] == true
                bgvid.show()
            else
                bgvid.hide()
            overlay_i += 1
            setTimeout(showStaticOverlay, overlays[i][2])

    montage_name = videos[0]
    videos = videos.slice(1)
    click_movie_function = ->
        if playing
            playing = false
            showStaticOverlay()
            player.loadVideoById
                videoId: get_video_url(videos, video_index)
                startSeconds: get_video_start(videos, video_index)
                endSeconds: get_video_end(videos, video_index)
                suggestedQuality: 'large'
            video_index += 1

    onPlayerStateChange = (event) ->
        if event.data == YT.PlayerState.PLAYING
            clearOverlay()
            if need_to_show_instructions and not iOS
                need_to_show_instructions = false
                instructions.show()
                instructions.fadeOut 5000
        else if event.data == YT.PlayerState.ENDED
            click_movie_function()

    overlay[0].addEventListener 'click', click_movie_function, true
    if ready
        click_movie_function()
    else
        onPlayerReady = ->
            click_movie_function()

    # Hide the cursor after 3 seconds
    do ->
        overlay = $("#overlay")
        mouseTimer = null
        cursorVisible = true

        disappearCursor = ->
            mouseTimer = null
            overlay.css('cursor', 'none')
            cursorVisible = false

        document.onmousemove = ->
            if mouseTimer
                window.clearTimeout mouseTimer
            if !cursorVisible
                overlay.css('cursor', 'e-resize')
                cursorVisible = true
            mouseTimer = window.setTimeout(disappearCursor, 3000)
