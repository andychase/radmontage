# The api key below is a public key
# It set to be "user-facing" and has a referrer-restriction set
api_key = "AIzaSyDNunorfrD4Wp21oL0F96Ov_L8mb9rdw_s"

youtube_api_endpoint = 'https://www.googleapis.com/youtube/v3/videos'
youtube_video_link = "https://www.youtube.com/watch?v="
youtube_channel_link = "https://www.youtube.com/channel/"

my_host_url = ""
get_endpoint = "#{my_host_url}/get.php"
save_endpoint = "#{my_host_url}/save.php"
new_endpoint = "#{my_host_url}/new.php"
watch_link = "#{my_host_url}/watch/"

montage_id = null
montage_secret = null
disable_saving = false

allowed_in_time_field = /[^0-9:]/g

## External Functions and Helpers
##

$.fn.moveUp = ->
    $.each this, ->
        $(this).after $(this).prev()

$.fn.moveDown = ->
    $.each this, ->
        $(this).before $(this).next()


edit_id_matcher = new RegExp("/edit/(new|[0-9a-z]+)")
get_edit_id = ->
    matches = window.location.pathname.match(edit_id_matcher)
    if matches? and matches.length > 1 and matches[1].length > 0
        return matches[1]

#
# Check if input string is a valid YouTube URL
# and try to extract the YouTube Video ID from it.
# @author  Stephan Schmitz <eyecatchup@gmail.com>
# @param   $url   string   The string that shall be checked.
# @return  mixed           Returns YouTube Video ID, or (boolean) false.
#
yt_matcher = do ->
    pattern = '(?:https?://)?'; # Optional URL scheme. Either http or https.
    pattern += '(?:www\\.|m\\.)?'; #  Optional www or m subdomain.
    pattern += '(?:'; #  Group host alternatives:
    pattern += 'youtu\\.be/'; #    Either youtu.be,
    pattern += '|youtube\\.com'; #    or youtube.com
    pattern += '|youtube\\.com'; #    or youtube.com
    pattern += '|i\\.ytimg\\.com'; #    or youtube.com
    pattern += ')'; #    End path alternatives.
    pattern += '(?:'; #    Group path alternatives:
    pattern += '/embed/'; #      Either /embed/,
    pattern += '|/v/'; #      or /v/,
    pattern += '|/vi/'; #      or /v/,
    pattern += '|/watch\\?v='; #      or /watch?v=,
    pattern += '|/watch\\?.+&v='; #      or /watch?other_param&v=
    pattern += ')'; #  End host alternatives. (https://i.ytimg.com/vi/5e_AjgKbceQ/mqdefault.jpg)
    pattern += '([A-Za-z0-9_\\- ]{11,})'; # 11 characters (Length of Youtube video ids).
    pattern += '(?:.+)?'; # Optional other ending URL parameters.
    return new RegExp(pattern)
yt_link_to_id = (url) ->
    matches = url.match(yt_matcher)
    if matches? and matches.length > 1 and matches[1].length > 0
        return matches[1]
##

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
    target.css("background-image", "url('/img/testCard.gif')")
    img = new Image

    img.onload = ->
        target.css("background-image", "")
        target.attr("src", url)

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

get_montage_title = ->
    if $("#montageName").val()?
        $("#montageName").val().replace(":", "")
    else
        ""

text_to_time = (value) ->
    value = value.replace(allowed_in_time_field, "")
    output = 0
    parts = value.split(":")
    if parts.length > 0
        output += parseInt(parts.pop())
    if parts.length > 0
        output += parseInt(parts.pop()) * 60
    if parts.length > 0
        output += parseInt(parts.pop()) * 60 * 60
    output

time_to_text = (value) ->
    if not parseInt(value)
        return 0
    value = parseInt(value)
    hours = value // (60 * 60)
    minutes = (value - (hours * 60 * 60)) // 60
    seconds = value - (hours * 60 * 60) - (minutes * 60)
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
<div class="row-container row montage-row">
    <img class="thumb img-responsive col-xs-4 col-lg-5" />

    <div class="row-box info-box-space col-xs-8 col-lg-7">
        <div class="montage-form-group">
            <h4 class="montageTitle">&nbsp;</h4>

            <div class="form-group">
                <label for="montageUrl1"></label>
                <input type="text" id="montageUrl1" class="form-control montageUrl"
                       placeholder="Paste a Youtube link here"/>
            </div>
            <div class="form-inline">
                <div class="form-group">
                    <label>Start:</label>
                    <input type="text" class="form-control montageStart" placeholder="0:00" maxlength="6"/>
                </div>
                <div class="form-group">
                    <label>Stop:</label>
                    <input type="text" class="form-control montageEnd" placeholder="99:99" maxlength="6"/>
                </div>
                <div class="form-group">
                    <div class="btn-group montage-link-buttons" role="group">
                        <a href="#" title="Delete this video" class="montage-delete btn btn-default"><i class="fa fa-times"></i></a>
                        <a href="#" title="Move this video up" class="montage-up btn btn-default"><i class="fa fa-chevron-up"></i></a>
                        <a href="#" title="Move this video down" class="montage-down btn btn-default"><i class="fa fa-chevron-down"></i></a>
                        <a href="#" title="Insert video spot above" class="montage-add-here btn btn-default"><i class="fa fa-plus"></i></a>
                    </div>
                </div>
            </div>
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
            append_new_video_container_if_none_left()
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
    new_container.find(".montageEnd, .montageStart").on("paste keydown", (e) ->
        setTimeout(->
            $(e.target).trigger('change');
        , 1);
    )
    url_target

append_new_video_container_if_none_left = ->
    if montage_link_container
        if montage_link_container.children().length > 1
            last = get_link_from_montage_container(montage_link_container.children().last())
            if last.val()? and last.val().trim().length
                append_new_video_container()
        else
            append_new_video_container()

montage_links = {}

montage_link_entered = (e) ->
    link_index = $(e.target.parentNode.parentNode.parentNode.parentNode).index()
    image_target = $(e.target.parentNode.parentNode.parentNode.parentNode).children(".thumb").first()
    title_target = $(e.target.parentNode.parentNode).children(".montageTitle").first()
    link_target = e.target.value
    if montage_links[link_index] == link_target and title_target.html() != "&nbsp;"
        return
    else
        montage_links[link_index] = link_target

    youtube_id = yt_link_to_id(link_target)
    if youtube_id?
        serializeAndSave()
        $(e.target.parentNode).addClass("has-success")
        set_video_image(image_target, link_to_img(youtube_id))
        set_video_title(title_target, youtube_id)
        append_new_video_container_if_none_left()
        return
    $(e.target.parentNode).removeClass("has-success")
    serializeAndSave()
    clear_video_image(image_target)
    clear_video_title(title_target)

unserialize = (data) ->
    if data? and data != ""
        data = data.split(":")
        montage_secret = data[0]
        montage_link_container.find("#montageName").val(data[1])
        data = data.slice(2)
        number_of_videos = data.length / 3
    else
        data = []
    if number_of_videos > 0
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
    montage_name = get_montage_title()
    data.push(montage_secret)
    data.push(montage_name)
    montage_link_container.children().each (i, container) ->
        link = get_link_from_montage_container($(container))
        youtube_id = null
        if link? and link.val()?
            youtube_id = yt_link_to_id(link.val().trim())
        if youtube_id?
            start = link.parent().parent().find(".montageStart")
            stop = link.parent().parent().find(".montageEnd")
            data.push(youtube_id)
            start_time = 0
            if start.val()? and start.val() != ""
                start_time = text_to_time(start.val())
                if start_time > 0
                    start.parent().addClass("has-success")
                else
                    start.parent().removeClass("has-success")
                data.push(start_time)
            else
                start.parent().removeClass("has-success")
                data.push(0)
            if stop.val()? and stop.val() != ""
                end_time = text_to_time(stop.val())
                if end_time > 0
                    if end_time > start_time
                        stop.parent().removeClass("has-error")
                        stop.parent().addClass("has-success")
                    else
                        end_time = 0
                        stop.parent().removeClass("has-success")
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

update_previous_montages = (link_data, remove_this_id) ->
    list_location = $("#previous-montages .dest")
    data = window.localStorage.getItem("data")
    if data? and data != ""
        data = data.split("||")
    else
        data = []
    previous_titles = {}
    for record_string in data
        record = record_string.split(":")
        previous_titles[record[0]] = record[1] # Id => title

    if montage_id?
        date = new Date()
        previous_titles["" + montage_id] = "#{get_montage_title()} #{date.getMonth() + 1}/#{date.getDate()}/#{date.getFullYear()}"
        if link_data? and link_data.split(":").length == 2
            delete previous_titles["" + montage_id]
        if remove_this_id
            delete previous_titles["" + remove_this_id]
        output = for id, title of previous_titles
            [id, title].join(":")
        window.localStorage.setItem("data", output.join("||"))

    previous_ids = Object.keys(previous_titles).sort().reverse()
    if previous_ids.length > 0
        list_location.empty()
    for id in previous_ids
        list_location.append($("<li><a href='/edit/#{id}'>#{previous_titles[id]}</a></li>"))


finishedSerializing = () ->
    rel_url = "#{watch_link}#{montage_id}"
    full_url = "https://radmontage.com#{watch_link}#{montage_id}"
    link_to_montage_html = """
    <a href="#{rel_url}" class="btn btn-default btn-sm" id="montage-play-button"><i class="fa fa-play"></i> Play</a>
    <span id="montage-manual-link">
        Link to share: <a href='#{rel_url}'>#{full_url}</a>
    </span>
    """
    $("#montage-link").html(link_to_montage_html)

last_saved = ""

serializeAndSave = () ->
    if disable_saving
        return
    data = serialize()
    anything_to_save = data? and data != "" and data.split(":").length > 2

    # Get new id and secret if we don't have one
    if anything_to_save and data != last_saved
        $("#montage-link").html("Saving...")
        if not montage_secret? or montage_secret == ""
            disable_saving = true # We have to disable saving otherwise the call for a new id/secret gets spammed
            return $.get(new_endpoint, {
                },
                (result) ->
                    disable_saving = false
                    montage_id = result.id
                    montage_secret = result.secret
                    history.replaceState(null, "", "/edit/#{montage_id}");
                    serializeAndSave()
            ,
                'json'
            )

        # Persist locally if possible
        if (window.localStorage)
            window.localStorage.setItem(montage_id, data)
            window.localStorage.setItem("last_worked_on", montage_id)

        if montage_secret? and montage_secret
            $.post(save_endpoint, {
                    id: montage_id
                    secret: montage_secret
                    data: data
                },
                ->
                    last_saved = data
                    finishedSerializing()
            ,
                'json'
            ).fail (xhr) ->
                if xhr.status == 403
                    montage_secret = null
                    update_previous_montages(null, montage_id)
                    serializeAndSave()

    update_previous_montages(data)

$ ->
    update_previous_montages()
    montage_link_container = $("#montage-links-container")
    if get_edit_id()?
        montage_id = get_edit_id()
        if montage_id == "new"
            montage_id = null
            window.localStorage.setItem("last_worked_on", "")

    last_worked_on = window.localStorage.getItem("last_worked_on")
    if not montage_id? and last_worked_on? and last_worked_on != ""
        montage_id = last_worked_on

    if montage_id?
        saved_data = window.localStorage.getItem(montage_id)
        if saved_data? and saved_data != ""
            unserialize(saved_data)
            history.replaceState(null, "", "/edit/#{montage_id}");
        else
            $.get(get_endpoint, {
                    id: montage_id
                },
                (result) ->
                    unserialize(":" + result.join(":"))
                    serializeAndSave()
            ,
                'json'
            )

        append_new_video_container_if_none_left()
    else
        append_new_video_container()

    $("#montageName").change ->
        serializeAndSave()
