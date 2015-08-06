api_key = "AIzaSyDNunorfrD4Wp21oL0F96Ov_L8mb9rdw_s"
youtube_api_endpoint = 'https://www.googleapis.com/youtube/v3/videos'
youtube_video_link = "https://www.youtube.com/watch?v="
youtube_channel_link = "https://www.youtube.com/channel/"

my_host_url = ""
save_endpoint = "#{my_host_url}/save.php"
new_endpoint = "#{my_host_url}/new.php"
watch_link = "#{my_host_url}/watch.html?m="

montage_id = null
montage_secret = null

allowed_in_time_field = /[^0-9:]/g

$.fn.moveUp = ->
    $.each this, ->
        $(this).after $(this).prev()

$.fn.moveDown = ->
    $.each this, ->
        $(this).before $(this).next()

ajax_channel_and_title = (id, func) ->
    $.ajax(
        url: youtube_api_endpoint
        data:
            part: 'snippet'
            id: id
            key: api_key
        localCache: true
        cacheTTL: 5
        dataType: 'json'
        cacheKey: id
    ).done (response) ->
        func(response)


link_to_img = (id) ->
    "https://i.ytimg.com/vi/#{id}/mqdefault.jpg"

set_video_image = (target, url) ->
    target.css("background-image", "url('img/testCard.gif')")
    img = new Image

    img.onload = ->
        target.css("background-image", "url('#{url}')")

    img.src = url

clear_video_image = (target) ->
    target.css("background-image", "")

video_title_markup = (channel_id, channel_title, title, id) ->
    "<a href='#{youtube_channel_link}#{channel_id}'>#{channel_title}</a>" +
        "<span>/</span><a href='#{youtube_video_link}#{id}'>#{title}</a>"

set_video_title = (target, id) ->
    ajax_channel_and_title id, (response) ->
        title = response.items[0].snippet.title
        channel_id = response.items[0].snippet.channelId
        channel_title = response.items[0].snippet.channelTitle
        target.html(video_title_markup(channel_id, channel_title, title, id))

clear_video_title = (target) ->
    target.html("&nbsp;")

text_to_time = (value) ->
    value = value.replace(allowed_in_time_field, "")
    output = 0
    parts = value.split(":")
    if parts.length > 0 and parseInt(parts[parts.length-1])
        output += parseInt(parts.pop())
    if parts.length > 0 and parseInt(parts[parts.length-1])
        output += parseInt(parts.pop()) * 60
    if parts.length > 0 and parseInt(parts[parts.length-1])
        output += parseInt(parts.pop()) * 60 * 60
    output

time_to_text = (value) ->
    if not parseInt(value)
        return 0
    value = parseInt(value)
    hours = value // (60*60)
    minutes = (value - (hours*60*60)) // 60
    seconds = value - (hours*60*60) - (minutes*60)
    if hours and minutes < 10
        minutes = "0" + minutes
    if minutes and seconds < 10
        seconds = "0" + seconds
    if hours
        [hours, minutes, seconds].join(":")
    else if minutes
        [minutes, seconds].join(":")
    else
        seconds

make_link_container = """
    <div class="row-container">
        <div class="row-box thumb">

        </div>
        <div class="row-box info-box-space">
            <div class="montage-form-group">
                <h2 class="montageTitle">&nbsp;</h2>

                <div class="form-group">
                    <label for="montageUrl1"></label>
                    <input type="text" id="montageUrl1" class="form-control montageUrl"
                           placeholder="Paste the Youtube link here"/>
                </div>
                <span class="form-inline">
                    <input type="text" class="form-control montageStart" placeholder="0:00" maxlength="6"/>
                </span>
                <span class="form-inline">
                    <input type="text" class="form-control montageEnd" placeholder="0:00" maxlength="6"/>
                </span>
                <span class="btn-group" role="group" aria-label="...">
                    <a href="#" class="montage-delete btn btn-default"><i class="fa fa-times"></i></a>
                    <a href="#" class="montage-up btn btn-default"><i class="fa fa-chevron-up"></i></a>
                    <a href="#" class="montage-down btn btn-default"><i class="fa fa-chevron-down"></i></a>
                </span>
                <a href="#" class="montage-add-here"><i class="fa fa-plus"></i></a>
            </div>
        </div>
    </div>
    """

montage_link_container = undefined
get_link_from_montage_container = (container) ->
    container.find(".montageUrl")

do_action_button_with_save = (container, selector, action) ->
    container.find(selector).click (e) ->
        e.preventDefault()
        action()
        serializeAndSave()

append_new_video_container = (target) ->
    # Make and add container
    new_container = $(make_link_container)
    new_container.hide()
    if target?
        target.before(new_container)
    else
        montage_link_container.append(new_container)
    new_container.slideDown 100

    url_target = get_link_from_montage_container(new_container)
    url_target.change(montage_link_entered)
    url_target.keyup(montage_link_entered)
    new_container.find(".montageStart").change ->
        serializeAndSave()
    new_container.find(".montageEnd").change ->
        serializeAndSave()
    new_container.find(".montage-add-here").click (e)->
        e.preventDefault()
        append_new_video_container(new_container)
    new_container.find(".montage-delete").click (e) ->
        e.preventDefault()
        new_container.slideUp 100, ->
            new_container.remove()
            serializeAndSave()
    do_action_button_with_save new_container, ".montage-up", ->
        if new_container.index() != 1
            new_container.moveUp()
    do_action_button_with_save new_container, ".montage-down", ->
        new_container.moveDown()

    $(url_target).on("paste", (e) ->
        setTimeout(->
            $(e.target).trigger('change');
        , 1);
    )
    url_target

append_new_video_container_if_none_left = ->
    if montage_link_container
        if get_link_from_montage_container(montage_link_container.children().last()).val().trim().length
            append_new_video_container()

montage_links = {}

montage_link_entered = (e) ->
    link_index = $(e.target.parentNode.parentNode.parentNode.parentNode).index()
    image_target = $(e.target.parentNode.parentNode.parentNode.parentNode).children(".thumb").first()
    title_target = $(e.target.parentNode.parentNode).children(".montageTitle").first()
    link_target = e.target.value
    if montage_links[link_index] == link_target
        return
    else
        montage_links[link_index] = link_target

    if link_target.split("=").length > 1
        id = link_target.split("=")[1].split("&")[0]
        if id.length == 11
            serializeAndSave()
            $(e.target.parentNode).addClass("has-success")
            set_video_image(image_target, link_to_img(id))
            set_video_title(title_target, id)
            append_new_video_container_if_none_left()
            return
    $(e.target.parentNode).removeClass("has-success")
    serializeAndSave()
    clear_video_image(image_target)
    clear_video_title(title_target)

unserialize = (data) ->
    data = data.split(":")
    data = data.slice(1)
    number_of_videos = data.length / 3
    for video_index in [0..number_of_videos - 1]
        link = append_new_video_container()
        start = link.parent().parent().find(".montageStart")
        stop = link.parent().parent().find(".montageEnd")
        link.attr("value", youtube_video_link + data[video_index * 3])
        if data[video_index * 3 + 1] != "0"
            start.attr("value", time_to_text(data[video_index * 3 + 1]))
        if data[video_index * 3 + 2] != "0"
            stop.attr("value", time_to_text(data[video_index * 3 + 2]))

    montage_link_container.children().each (i, container) ->
        get_link_from_montage_container($(container)).trigger('change')

serialize = () ->
    data = []
    montage_name = $("#montageName").val()
    data.push(montage_name)
    montage_link_container.children().each (i, container) ->
        link = get_link_from_montage_container($(container))
        if link? and link.length and link.val().trim().split("=").length > 1
            start = link.parent().parent().find(".montageStart")
            stop = link.parent().parent().find(".montageEnd")
            link_data = link.val().trim().split("=")[1]
            data.push(link_data)
            start_time = 0
            if start.val() != ""
                start_time = text_to_time(start.val())
                if start_time > 0
                    start.parent().addClass("has-success")
                data.push(start_time)
            else
                start.parent().removeClass("has-success")
                data.push(0)
            if stop.val() != ""
                end_time = text_to_time(stop.val())
                if end_time > 0
                    if end_time > start_time
                        stop.parent().removeClass("has-error")
                        stop.parent().addClass("has-success")
                    else
                        end_time = 0
                        stop.parent().addClass("has-error")
                else
                    stop.parent().removeClass("has-error")
                    stop.parent().removeClass("has-success")
                data.push(end_time)
            else
                stop.parent().removeClass("has-error")
                stop.parent().removeClass("has-success")
                data.push(0)
    data.join(":")

finishedSerializing = () ->
    $("#montage-link").html("<a href='#{watch_link}#{montage_id}'>https://radmontage.herokuapp.com#{watch_link}#{montage_id}</a>")

serializeAndSave = () ->
    data = serialize()

    # Get new id and secret if we don't have one
    if data.length
        $("#montage-link").html("Saving...")
        if not montage_id? or not montage_secret?
            $.get(new_endpoint, {
                },
                (result) ->
                    montage_id = result.id
                    montage_secret = result.secret
                    serializeAndSave()
            ,
                'json'
            )

        # Persist locally if possible
        if (window.localStorage)
            window.localStorage.setItem("data", data)
            window.localStorage.setItem("id", montage_id)
            window.localStorage.setItem("secret", montage_secret)

        if montage_secret
            $.post(save_endpoint, {
                    id: montage_id
                    secret: montage_secret
                    data: data
                },
                finishedSerializing,
                'json'
            )

$ ->
    montage_link_container = $("#montage-links-container")
    if (window.localStorage && window.localStorage.getItem("data"))
        montage_id = window.localStorage.getItem("id")
        montage_secret = window.localStorage.getItem("secret")
        unserialize(window.localStorage.getItem("data"))
    else
        append_new_video_container()

    $("#montageName").change ->
        serializeAndSave()
