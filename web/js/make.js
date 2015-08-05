// Generated by CoffeeScript 1.9.3
var ajax_channel_and_title, api_key, append_new_video_container, append_new_video_container_if_none_left, clear_video_image, clear_video_title, finishedSerializing, get_link_from_montage_container, link_to_img, make_link_container, montage_id, montage_link_container, montage_link_entered, montage_secret, my_host_url, new_endpoint, save_endpoint, serialize, serializeAndSave, set_video_image, set_video_title, unserialize, video_title_markup, watch_link, youtube_api_endpoint, youtube_channel_link, youtube_video_link;

api_key = "AIzaSyDNunorfrD4Wp21oL0F96Ov_L8mb9rdw_s";

youtube_api_endpoint = 'https://www.googleapis.com/youtube/v3/videos';

youtube_video_link = "https://www.youtube.com/watch?v=";

youtube_channel_link = "https://www.youtube.com/channel/";

my_host_url = "";

save_endpoint = my_host_url + "/save.php";

new_endpoint = my_host_url + "/new.php";

watch_link = my_host_url + "/watch.html?m=";

montage_id = null;

montage_secret = null;

ajax_channel_and_title = function(id, func) {
  return $.ajax({
    url: youtube_api_endpoint,
    data: {
      part: 'snippet',
      id: id,
      key: api_key
    },
    localCache: true,
    cacheTTL: 5,
    dataType: 'json',
    cacheKey: id
  }).done(function(response) {
    return func(response);
  });
};

link_to_img = function(id) {
  return "https://i.ytimg.com/vi/" + id + "/mqdefault.jpg";
};

set_video_image = function(target, url) {
  var img;
  target.css("background-image", "url('img/testCard.gif')");
  img = new Image;
  img.onload = function() {
    return target.css("background-image", "url('" + url + "')");
  };
  return img.src = url;
};

clear_video_image = function(target) {
  return target.css("background-image", "");
};

video_title_markup = function(channel_id, channel_title, title, id) {
  return ("<a href='" + youtube_channel_link + channel_id + "'>" + channel_title + "</a>") + ("<span>/</span><a href='" + youtube_video_link + id + "'>" + title + "</a>");
};

set_video_title = function(target, id) {
  return ajax_channel_and_title(id, function(response) {
    var channel_id, channel_title, title;
    title = response.items[0].snippet.title;
    channel_id = response.items[0].snippet.channelId;
    channel_title = response.items[0].snippet.channelTitle;
    return target.html(video_title_markup(channel_id, channel_title, title, id));
  });
};

clear_video_title = function(target) {
  return target.html("&nbsp;");
};

make_link_container = "<div class=\"row-container\">\n        <div class=\"row-box thumb\">\n\n        </div>\n        <div class=\"row-box info-box-space\">\n            <div class=\"montage-form-group\">\n                <h2 class=\"montageTitle\">&nbsp;</h2>\n                <label for=\"montageUrl1\"></label>\n                <input type=\"text\" id=\"montageUrl1\" class=\"form-control montageUrl\" placeholder=\"Paste the Youtube link here\"/>\n                <div class=\"form-inline\">\n                    <input type=\"text\" id=\"montageStart1\" class=\"form-control montageStart\" placeholder=\"0:00\" maxlength=\"6\"/>\n                    <input type=\"text\" id=\"montageEnd1\" class=\"form-control montageEnd\" placeholder=\"0:00\" maxlength=\"6\"/>\n                </div>\n            </div>\n        </div>\n    </div>";

montage_link_container = void 0;

get_link_from_montage_container = function(container) {
  return container.children(".info-box-space").children(".montage-form-group").children(".montageUrl");
};

append_new_video_container = function() {
  var new_container, url_target;
  new_container = $(make_link_container);
  montage_link_container.append(new_container);
  url_target = get_link_from_montage_container(new_container);
  url_target.change(montage_link_entered);
  $(url_target).on("paste", function(e) {
    return setTimeout(function() {
      return $(e.target).trigger('change');
    }, 1);
  });
  return url_target;
};

append_new_video_container_if_none_left = function() {
  if (montage_link_container) {
    if (get_link_from_montage_container(montage_link_container.children().last()).val().trim().length) {
      return append_new_video_container();
    }
  }
};

montage_link_entered = function(e) {
  var id, image_target, title_target;
  image_target = $(e.target.parentNode.parentNode.parentNode).children(".thumb").first();
  title_target = $(e.target.parentNode).children(".montageTitle").first();
  if (e.target.value.split("=").length > 1) {
    id = e.target.value.split("=")[1].split("&")[0];
    if (id.length === 11) {
      serializeAndSave();
      set_video_image(image_target, link_to_img(id));
      set_video_title(title_target, id);
      append_new_video_container_if_none_left();
      return;
    }
  }
  serializeAndSave();
  clear_video_image(image_target);
  return clear_video_title(title_target);
};

unserialize = function(data) {
  var j, link, number_of_videos, ref, start, stop, video_index;
  data = data.split(":");
  data = data.slice(1);
  number_of_videos = data.length / 3;
  for (video_index = j = 0, ref = number_of_videos - 1; 0 <= ref ? j <= ref : j >= ref; video_index = 0 <= ref ? ++j : --j) {
    link = append_new_video_container();
    start = link.siblings(".montageStart").first();
    stop = link.siblings(".montageEnd").first();
    link.attr("value", youtube_video_link + data[video_index * 3]);
    if (data[video_index * 3 + 1] !== 0) {
      start.attr("value", data[video_index * 3 + 1]);
    }
    if (data[video_index * 3 + 2] !== 0) {
      stop.attr("value", data[video_index * 3 + 2]);
    }
  }
  return montage_link_container.children().each(function(i, container) {
    return get_link_from_montage_container($(container)).trigger('change');
  });
};

serialize = function() {
  var data, montage_name;
  data = [];
  montage_name = $("#montageName").val();
  data.push(montage_name);
  montage_link_container.children().each(function(i, container) {
    var link, link_data, start, stop;
    link = get_link_from_montage_container($(container));
    if ((link != null) && link.length && link.val().trim().split("=").length > 1) {
      start = link.siblings(".montageStart").first();
      stop = link.siblings(".montageEnd").first();
      link_data = link.val().trim().split("=")[1];
      data.push(link_data);
      if (start.val() !== "") {
        data.push(start.val());
      } else {
        data.push(0);
      }
      if (stop.val() !== "") {
        return data.push(stop.val());
      } else {
        return data.push(0);
      }
    }
  });
  return data.join(":");
};

finishedSerializing = function() {
  return $("#montage-link").html("<a href='" + watch_link + montage_id + "'>" + watch_link + montage_id + "</a>");
};

serializeAndSave = function() {
  var data;
  data = serialize();
  if (data.length) {
    $("#montage-link").html("Saving...");
    if ((montage_id == null) || (montage_secret == null)) {
      $.get(new_endpoint, {}, function(result) {
        montage_id = result.id;
        montage_secret = result.secret;
        return serializeAndSave();
      }, 'json');
    }
    if (window.localStorage) {
      window.localStorage.setItem("data", data);
      window.localStorage.setItem("id", montage_id);
      window.localStorage.setItem("secret", montage_secret);
    }
    if (montage_secret) {
      return $.post(save_endpoint, {
        id: montage_id,
        secret: montage_secret,
        data: data
      }, finishedSerializing, 'json');
    }
  }
};

$(function() {
  montage_link_container = $("#montage-links-container");
  if (window.localStorage && window.localStorage.getItem("data")) {
    montage_id = window.localStorage.getItem("id");
    montage_secret = window.localStorage.getItem("secret");
    unserialize(window.localStorage.getItem("data"));
  } else {
    append_new_video_container();
  }
  return $("#montageName").change(function() {
    return serializeAndSave();
  });
});
