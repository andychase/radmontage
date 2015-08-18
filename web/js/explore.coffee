do ->
    $.fn.slideview = (slides, settings) ->
        @each ->
            init this, slides, settings


    init = (element, slides, settings) ->
        if $.isFunction(slides)
            slides = slides(element)
        size = settings.size or 300

        $viewport = $(element).css(
            overflow: 'hidden'
        ).addClass('slideview-viewport').empty()

        $container = $('<div></div>')
        $container.css
            overflow: 'hidden'
            margin: 0
            padding: 0
            border: 0
            position: 'relative'
            width: size * slides.length + 'px'
        $container.addClass('slideview-container')
        $container.appendTo($viewport)

        for i of slides
            el = $("<div><img src='#{slides[i]}' alt='' style='width: 300px; height: 169px;'/></div>")
            el.css
                margin: 0
                padding: 0
                width: size + 'px'
                overflow: 'hidden'
                'float': 'left'
                border: 0
            el.addClass('slideview-slide')
            el.appendTo $container

        $viewport.bind 'mousemove', (evt) ->
            x = Math.max(1, evt.offsetX)
            offset = Math.floor(x / (size / slides.length)) * size
            $container.css 'right', offset
            false

$ ->
    if window.montage_images?
        to_img = (id) -> "https://i.ytimg.com/vi/#{id}/mqdefault.jpg"
        $('.explore-video-thumb').slideview ((element) ->
            if window.montage_images[element.id]?
                for id in window.montage_images[element.id]
                    to_img(id)
        ), size: 320

    iframe = $("#watch-video-iframe")
    if iframe?
        previous_movie_function = () ->
            iframe[0].contentWindow.previous_movie_function();
        play_pause = () ->
            iframe[0].contentWindow.play_pause_movie_function()
        skip = () ->
            iframe[0].contentWindow.click_movie_function()
        $("#watch-control-previous").click ->
            previous_movie_function()
        $("#watch-control-play-pause").click ->
            play_pause()
        $("#watch-control-skip").click ->
            skip()
