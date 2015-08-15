videos = window.videos
players = []
player_index = 0
iOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
ready = [false, false]
testCardImageBasePath = "https://d12gd74eaa9d1v.cloudfront.net/"

toggleFullScreen = ->
    if !document.fullscreenElement and !document.mozFullScreenElement and !document.webkitFullscreenElement and !document.msFullscreenElement

        if document.documentElement.requestFullscreen
            document.documentElement.requestFullscreen()
        else if document.documentElement.msRequestFullscreen
            document.documentElement.msRequestFullscreen()
        else if document.documentElement.mozRequestFullScreen
            document.documentElement.mozRequestFullScreen()
        else if document.documentElement.webkitRequestFullscreen
            document.documentElement.webkitRequestFullscreen Element.ALLOW_KEYBOARD_INPUT
    else
        if document.exitFullscreen
            document.exitFullscreen()
        else if document.msExitFullscreen
            document.msExitFullscreen()
        else if document.mozCancelFullScreen
            document.mozCancelFullScreen()
        else if document.webkitExitFullscreen
            document.webkitExitFullscreen()

onYouTubeIframeAPIReady = ->
    $ ->
        players.push new YT.Player('player',
            playerVars:
                controls: 0
                showinfo: 0
                iv_load_policy: 3

            events:
                onReady: () -> onPlayerReady()
                onStateChange: (e) -> onPlayerStateChange(e)
        )

        players.push new YT.Player('player2',
            playerVars:
                controls: 0
                showinfo: 0
                iv_load_policy: 3

            events:
                onReady: () -> onPlayerReady2()
                onStateChange: (e) -> onPlayerStateChange2(e)
                onError: (e) ->
                    console.log(e)
        )


onPlayerReady = () ->
    ready[0] = true

onPlayerStateChange = () ->


onPlayerReady2 = () ->
    ready[1] = true

onPlayerStateChange2 = () ->


get_other_player_index = () ->
    if player_index == 0
        1
    else
        0

toggle_player_index = () ->
    player_index = get_other_player_index()

if_zero_return_null = (i) ->
    if i == 0
        null
    else
        parseInt(i)

get_video_url = (videos, video_index) ->
    videos[3 * video_index]

get_video_start = (videos, video_index) ->
    if_zero_return_null(videos[3 * video_index + 1])


get_video_end = (videos, video_index) ->
    if_zero_return_null(videos[3 * video_index + 2])

video_end = (container, end_splash) ->
    $("body").addClass("video-done");
    $("html").addClass("video-done");
    container.hide()
    container.remove()
    end_splash.show()
    if iOS
        $('.adsbygoogle').hide()
        $('ios_code').appendTo($("head"))
    else
        (window.adsbygoogle or []).push {}

$ ->
    instructions = $("#instructions")
    need_to_show_instructions = true
    overlay = $('#overlay')
    end_splash = $('#end-splash')
    player_html = undefined # Must be calculated after players are ready
    video_index = 0

    if iOS
        overlay.addClass("ios")
        instructions.addClass("ios")

    # montage_name = videos[0]
    videos = videos.slice(1)
    not_end_of_videos = ->
        video_index < (videos.length / 3)

    click_movie_function = ->
        if not_end_of_videos()
            if video_index == 0
                players[player_index].loadVideoById
                    videoId: get_video_url(videos, video_index)
                    startSeconds: get_video_start(videos, video_index)
                    endSeconds: get_video_end(videos, video_index)
                    suggestedQuality: 'large'
            player_html[player_index].css('z-index', 2)
            players[player_index].playVideo()
            toggle_player_index()
            player_html[player_index].css('z-index', 1)
            video_index += 1
            if not_end_of_videos()
                players[player_index].loadVideoById
                    videoId: get_video_url(videos, video_index)
                    startSeconds: get_video_start(videos, video_index)
                    endSeconds: get_video_end(videos, video_index)
                    suggestedQuality: 'large'
                players[player_index].pauseVideo()
            else
                players[player_index].stopVideo()
        else
            players[0].stopVideo()
            players[1].stopVideo()
            document.onmousemove = null
            video_end(overlay.parent(), end_splash)

    window.click_movie_function = click_movie_function
    window.play_pause_movie_function = () ->
        player = players[get_other_player_index()]
        if player.getPlayerState() == YT.PlayerState.PLAYING
            player.pauseVideo()
        else if player.getPlayerState() == YT.PlayerState.PAUSED
            player.playVideo()

    onPlayerStateChange = (event) ->
        if event.data == YT.PlayerState.PLAYING
            if need_to_show_instructions and not iOS
                need_to_show_instructions = false
                instructions.show()
                window.setTimeout ->
                    instructions.fadeOut 500
                , 2500
        else if event.data == YT.PlayerState.ENDED
            if player_index == 1
                click_movie_function()

    onPlayerStateChange2 = (event) ->
        if event.data == YT.PlayerState.ENDED
            if player_index == 0
                click_movie_function()

    overlay[0].addEventListener 'click', click_movie_function, true
    if ready[0] and ready[1]
        click_movie_function()
    else
        onPlayerReady = ->
            ready[0] = true
            if ready[0] and ready[1]
                player_html = [$("#player"), $("#player2")]
                click_movie_function()
        onPlayerReady2 = ->
            ready[1] = true
            if ready[0] and ready[1]
                player_html = [$("#player"), $("#player2")]
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
                overlay.css('cursor', "url('/img/forward_cursor.png') 0 0, e-resize")
                cursorVisible = true
            mouseTimer = window.setTimeout(disappearCursor, 3000)
