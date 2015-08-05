api_key = "AIzaSyDNunorfrD4Wp21oL0F96Ov_L8mb9rdw_s"
youtube_api_endpoint = 'https://www.googleapis.com/youtube/v3/videos'
youtube_video_link = "https://www.youtube.com/watch?v="
youtube_channel_link = "https://www.youtube.com/channel/"

my_host_url = "https://radmontage.herokuapp.com"
save_endpoint = "#{my_host_url}/save.php"
new_endpoint = "#{my_host_url}/new.php"
watch_link = "#{my_host_url}/watch.html?m="

montage_id = null
montage_secret = null


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

make_link_container = """
    <div class="row-container">
            <div class="row-box thumb">

            </div>
            <div class="row-box info-box-space">
                <div class="montage-form-group">
                    <h2 class="montageTitle">&nbsp;</h2>
                    <label for="montageUrl1"></label>
                    <input type="text" id="montageUrl1" class="montageUrl" placeholder="Paste the Youtube link here"/><br/>
                    <input type="text" id="montageStart1" class="montageStart" placeholder="0:00" maxlength="6"/>
                    <input type="text" id="montageEnd1" class="montageEnd" placeholder="0:00" maxlength="6"/>
                </div>
            </div>
        </div>
        """

montage_link_container = undefined
get_link_from_montage_container = (container) ->
    container.children(".info-box-space").children(".montage-form-group").children(".montageUrl")

append_new_video_container = ->
    new_container = $(make_link_container)
    montage_link_container.append(new_container)
    url_target = get_link_from_montage_container(new_container)
    url_target.change(montage_link_entered)
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

montage_link_entered = (e) ->
    image_target = $(e.target.parentNode.parentNode.parentNode).children(".thumb").first()
    title_target = $(e.target.parentNode).children(".montageTitle").first()
    if e.target.value.split("=").length > 1
        id = e.target.value.split("=")[1].split("&")[0]
        if id.length == 11
            serializeAndSave()
            set_video_image(image_target, link_to_img(id))
            set_video_title(title_target, id)
            append_new_video_container_if_none_left()
            return
    serializeAndSave()
    clear_video_image(image_target)
    clear_video_title(title_target)

unserialize = (data) ->
    data = data.split(":")
    data = data.slice(1)
    number_of_videos = data.length / 3
    for video_index in [0..number_of_videos - 1]
        link = append_new_video_container()
        start = link.siblings(".montageStart").first()
        stop = link.siblings(".montageEnd").first()
        link.attr("value", youtube_video_link + data[video_index * 3])
        if data[video_index * 3 + 1] != 0
            start.attr("value", data[video_index * 3 + 1])
        if data[video_index * 3 + 2] != 0
            stop.attr("value", data[video_index * 3 + 2])

    montage_link_container.children().each (i, container) ->
        get_link_from_montage_container($(container)).trigger('change')

serialize = () ->
    data = []
    montage_name = $("#montageName").val()
    data.push(montage_name)
    montage_link_container.children().each (i, container) ->
        link = get_link_from_montage_container($(container))
        if link? and link.length and link.val().trim().split("=").length > 1
            start = link.siblings(".montageStart").first()
            stop = link.siblings(".montageEnd").first()
            link_data = link.val().trim().split("=")[1]
            data.push(link_data)
            if start.val() != ""
                data.push(start.val())
            else
                data.push(0)
            if stop.val() != ""
                data.push(stop.val())
            else
                data.push(0)
    data.join(":")

finishedSerializing = () ->
    $("#montage-link").html("<a href='#{watch_link}#{montage_id}'>#{watch_link}#{montage_id}</a>")

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