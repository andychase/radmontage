api_key = "AIzaSyDNunorfrD4Wp21oL0F96Ov_L8mb9rdw_s"
youtube_api_endpoint = 'https://www.googleapis.com/youtube/v3/videos'
youtube_video_link = "https://www.youtube.com/watch?v="
youtube_channel_link = "https://www.youtube.com/channel/"


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

video_title_markup = (channel_id, channel_title, title, id) ->
    "<a href='#{youtube_channel_link}#{channel_id}'>#{channel_title}</a>" +
    "<span>/</span><a href='#{youtube_video_link}#{id}'>#{title}</a>"

set_video_title = (target, id) ->
    ajax_channel_and_title id, (response) ->
        title = response.items[0].snippet.title
        channel_id = response.items[0].snippet.channelId
        channel_title = response.items[0].snippet.channelTitle
        target.html(video_title_markup(channel_id, channel_title, title, id))

make_link_container = """
    <div class="row-container">
            <div class="row-box thumb">

            </div>
            <div class="row-box info-box-space">
                <div class="montage-form-group">
                    <h2 class="montageTitle">&nbsp;</h2>
                    <label for="montageUrl1"></label>
                    <input type="text" id="montageUrl1" class="montageUrl" placeholder="Put the youtube url here"/><br/>
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
    url_target.keydown(montage_link_entered)

append_new_video_container_if_empty = ->
    if montage_link_container
        if get_link_from_montage_container(montage_link_container.children().last()).val().trim().length
            append_new_video_container()

montage_link_entered = (e) ->
    if e.target.value.split("=").length > 1
        id = e.target.value.split("=")[1].split("&")[0]
        if id.length == 11
            target = $(e.target.parentNode.parentNode.parentNode).children(".thumb").first()
            set_video_image(target, link_to_img(id))
            target = $(e.target.parentNode).children(".montageTitle").first()
            set_video_title(target, id)
            append_new_video_container_if_empty()


$ ->
    montage_link_container = $("#montage-links-container")
    append_new_video_container()
