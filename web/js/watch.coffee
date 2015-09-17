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
                iv_load_policy: 3

            events:
                onReady: () -> onPlayerReady()
                onStateChange: (e) -> onPlayerStateChange(e)
        )

        players.push new YT.Player('player2',
            playerVars:
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


get_currently_playing_id = () ->
    if player_index == 0
        1
    else
        0

toggle_player_index = () ->
    player_index = get_currently_playing_id()

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
    container = $('#container')
    end_splash = $('#end-splash')
    player_html = undefined # Must be calculated after players are ready
    video_index = 0

    # montage_name = videos[0]
    videos = videos.slice(1)
    not_end_of_videos = ->
        video_index < (videos.length / 3)

    # This next part handles skipping videos at the last second
    # to avoid the "recommended videos" flash
    timer = null
    startTick = ->
        current_player = players[get_currently_playing_id()]
        if get_video_end(videos, video_index-1)? and get_video_end(videos, video_index-1) != 0
            end_time = get_video_end(videos, video_index-1)
        else
            end_time = current_player.getDuration()

        timeout_time = 900
        next_tick_skips = false
        tick = ->
            timer = setTimeout ->
                current_time = current_player.getCurrentTime()
                if next_tick_skips
                    click_movie_function()
                else if (timeout_time == 900) and current_time + 1.5 > end_time
                    timeout_time = 50
                    tick()
                else if current_time + .5 > end_time
                    # Schedule a "skip" about 100 ms from close end to prevent end screen from showing
                    timeout_time = Math.floor((end_time - current_time - .1) * 1000)
                    next_tick_skips = true
                    tick()
                    # Start pre-playing the next video to reduce black flashes
                    players[player_index].playVideo()
                    setTimeout ->
                        players[player_index].pauseVideo()
                    , 100
                else
                    tick()
            , timeout_time
        tick()

    stopTick = ->
        clearTimeout(timer)

    # This function handles progressing to the next video (or first video)
    click_movie_function = ->
        if not_end_of_videos()
            if video_index == 0
                players[player_index].loadVideoById
                    videoId: get_video_url(videos, video_index)
                    startSeconds: get_video_start(videos, video_index)
                    endSeconds: get_video_end(videos, video_index)
                    suggestedQuality: 'default'
            player_html[player_index].css('z-index', 2)
            player_html[player_index].css('visibility', 'visible')
            if window.location.search.replace("?", "").indexOf("slow=true") > -1
                players[player_index].setPlaybackRate(0.5)
            players[player_index].playVideo()
            toggle_player_index()
            player_html[player_index].css('z-index', 1)
            player_html[player_index].css('visibility', 'hidden')
            video_index += 1
            if not_end_of_videos()
                players[player_index].loadVideoById
                    videoId: get_video_url(videos, video_index)
                    startSeconds: get_video_start(videos, video_index)
                    endSeconds: get_video_end(videos, video_index)
                    suggestedQuality: 'default'
                players[player_index].pauseVideo()
            else
                players[player_index].stopVideo()
        else
            players[0].stopVideo()
            players[1].stopVideo()
            document.onmousemove = null
            video_end(container, end_splash)

    # These functions are control functions that can be called from a parent frame
    window.click_movie_function = click_movie_function
    window.previous_movie_function = ->
        if video_index == 1
            if get_video_start(videos, 0)?
                players[get_currently_playing_id()].seekTo get_video_start(videos, 0)
            else
                players[get_currently_playing_id()].seekTo 0
        else
            players[0].pauseVideo()
            players[1].pauseVideo()
            video_index -= 2
            players[player_index].loadVideoById
                videoId: get_video_url(videos, video_index)
                startSeconds: get_video_start(videos, video_index)
                endSeconds: get_video_end(videos, video_index)
                suggestedQuality: 'default'
            click_movie_function()

    window.play_pause_movie_function = () ->
        player = players[get_currently_playing_id()]
        if player.getPlayerState() == YT.PlayerState.PLAYING
            player.pauseVideo()
        else if player.getPlayerState() == YT.PlayerState.PAUSED
            player.playVideo()

    onPlayerStateChange = (event) ->
        if get_currently_playing_id() == 0
            stopTick()
            if event.data == YT.PlayerState.PLAYING
                startTick()
                if need_to_show_instructions and not iOS
                    need_to_show_instructions = false
                    instructions.show()
                    window.setTimeout ->
                        instructions.fadeOut 500
                    , 2500
            else if event.data == YT.PlayerState.ENDED
                click_movie_function()

    onPlayerStateChange2 = (event) ->
        if get_currently_playing_id() == 1
            stopTick()
            if event.data == YT.PlayerState.PLAYING
                startTick()
            else if event.data == YT.PlayerState.ENDED
                click_movie_function()

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
