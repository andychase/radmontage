// Generated by CoffeeScript 1.9.3
var ajax_channel_and_title, allowed_in_time_field, allowed_in_title_field, api_key, append_new_video_container, append_new_video_container_if_none_left, clear_video_image, clear_video_title, disable_saving, do_action_button_with_save, edit_id_matcher, finishedSerializing, get_edit_id, get_endpoint, get_link_from_montage_container, get_montage_title, last_saved, link_to_img, make_link_container, montage_id, montage_link_container, montage_link_entered, montage_links, montage_secret, my_host_url, new_endpoint, save_endpoint, serialize, serializeAndSave, set_video_image, set_video_title, text_to_time, time_to_text, unserialize, update_previous_montages, video_title_markup, watch_link, youtube_api_endpoint, youtube_channel_link, youtube_video_link, yt_link_to_id, yt_matcher;

api_key = "AIzaSyDNunorfrD4Wp21oL0F96Ov_L8mb9rdw_s";

youtube_api_endpoint = 'https://www.googleapis.com/youtube/v3/videos';

youtube_video_link = "https://www.youtube.com/watch?v=";

youtube_channel_link = "https://www.youtube.com/channel/";

my_host_url = "";

get_endpoint = my_host_url + "/get.php";

save_endpoint = my_host_url + "/save.php";

new_endpoint = my_host_url + "/new.php";

watch_link = my_host_url + "/watch/";

montage_id = null;

montage_secret = null;

disable_saving = false;

allowed_in_time_field = /[^0-9:]/g;

allowed_in_title_field = /[^A-Za-z0-9_ ]/;

$.fn.moveUp = function() {
  return $.each(this, function() {
    return $(this).after($(this).prev());
  });
};

$.fn.moveDown = function() {
  return $.each(this, function() {
    return $(this).before($(this).next());
  });
};

edit_id_matcher = new RegExp("/edit/(new|[0-9a-z]+)");

get_edit_id = function() {
  var matches;
  matches = window.location.pathname.match(edit_id_matcher);
  if ((matches != null) && matches.length > 1 && matches[1].length > 0) {
    return matches[1];
  }
};

yt_matcher = (function() {
  var pattern;
  pattern = '(?:https?://)?';
  pattern += '(?:www\\.|m\\.)?';
  pattern += '(?:';
  pattern += 'youtu\\.be/';
  pattern += '|youtube\\.com';
  pattern += '|youtube\\.com';
  pattern += '|i\\.ytimg\\.com';
  pattern += ')';
  pattern += '(?:';
  pattern += '/embed/';
  pattern += '|/v/';
  pattern += '|/vi/';
  pattern += '|/watch\\?v=';
  pattern += '|/watch\\?.+&v=';
  pattern += ')';
  pattern += '([A-Za-z0-9_\\- ]{11,})';
  pattern += '(?:.+)?';
  return new RegExp(pattern);
})();

yt_link_to_id = function(url) {
  var matches;
  matches = url.match(yt_matcher);
  if ((matches != null) && matches.length > 1 && matches[1].length > 0) {
    return matches[1];
  }
};

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
  target.css("background-image", "url('/img/testCard.gif')");
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

get_montage_title = function() {
  if ($("#montageName").val() != null) {
    return $("#montageName").val().replace(allowed_in_title_field, "");
  } else {
    return "";
  }
};

text_to_time = function(value) {
  var output, parts;
  value = value.replace(allowed_in_time_field, "");
  output = 0;
  parts = value.split(":");
  if (parts.length > 0 && parseInt(parts[parts.length - 1])) {
    output += parseInt(parts.pop());
  }
  if (parts.length > 0 && parseInt(parts[parts.length - 1])) {
    output += parseInt(parts.pop()) * 60;
  }
  if (parts.length > 0 && parseInt(parts[parts.length - 1])) {
    output += parseInt(parts.pop()) * 60 * 60;
  }
  return output;
};

time_to_text = function(value) {
  var hours, minutes, seconds;
  if (!parseInt(value)) {
    return 0;
  }
  value = parseInt(value);
  hours = Math.floor(value / (60 * 60));
  minutes = Math.floor((value - (hours * 60 * 60)) / 60);
  seconds = value - (hours * 60 * 60) - (minutes * 60);
  if (hours && minutes < 10) {
    minutes = "0" + minutes;
  }
  if (minutes && seconds < 10) {
    seconds = "0" + seconds;
  }
  if (hours) {
    return [hours, minutes, seconds].join(":");
  } else if (minutes) {
    return [minutes, seconds].join(":");
  } else {
    return seconds;
  }
};

make_link_container = "<div class=\"row-container\">\n    <div class=\"row-box thumb\">\n\n    </div>\n    <div class=\"row-box info-box-space\">\n        <div class=\"montage-form-group\">\n            <h2 class=\"montageTitle\">&nbsp;</h2>\n\n            <div class=\"form-group\">\n                <label for=\"montageUrl1\"></label>\n                <input type=\"text\" id=\"montageUrl1\" class=\"form-control montageUrl\"\n                       placeholder=\"Paste the Youtube link here\"/>\n            </div>\n            <span class=\"form-inline\">\n                <label>Start:</label>\n                <input type=\"text\" class=\"form-control montageStart\" placeholder=\"0:00\" maxlength=\"6\"/>\n\n            </span>\n            <span class=\"form-inline\">\n                <label>Stop:</label>\n                <input type=\"text\" class=\"form-control montageEnd\" placeholder=\"99:99\" maxlength=\"6\"/>\n            </span>\n            <span class=\"btn-group montage-link-buttons\" role=\"group\" aria-label=\"...\">\n                <a href=\"#\" class=\"montage-delete btn btn-default\"><i class=\"fa fa-times\"></i></a>\n                <a href=\"#\" class=\"montage-up btn btn-default\"><i class=\"fa fa-chevron-up\"></i></a>\n                <a href=\"#\" class=\"montage-down btn btn-default\"><i class=\"fa fa-chevron-down\"></i></a>\n            </span>\n            <a href=\"#\" class=\"montage-add-here\"><i class=\"fa fa-plus\"></i></a>\n        </div>\n    </div>\n</div>";

montage_link_container = void 0;

get_link_from_montage_container = function(container) {
  return container.find(".montageUrl");
};

do_action_button_with_save = function(container, selector, action) {
  return container.find(selector).click(function(e) {
    e.preventDefault();
    action();
    return serializeAndSave();
  });
};

append_new_video_container = function(target) {
  var new_container, url_target;
  new_container = $(make_link_container);
  new_container.hide();
  if (target != null) {
    target.before(new_container);
  } else {
    montage_link_container.append(new_container);
  }
  new_container.slideDown(100);
  url_target = get_link_from_montage_container(new_container);
  url_target.change(montage_link_entered);
  url_target.keyup(montage_link_entered);
  new_container.find(".montageStart").change(function() {
    return serializeAndSave();
  });
  new_container.find(".montageEnd").change(function() {
    return serializeAndSave();
  });
  new_container.find(".montage-add-here").click(function(e) {
    e.preventDefault();
    return append_new_video_container(new_container);
  });
  new_container.find(".montage-delete").click(function(e) {
    e.preventDefault();
    return new_container.slideUp(100, function() {
      new_container.remove();
      serializeAndSave();
      return append_new_video_container_if_none_left();
    });
  });
  do_action_button_with_save(new_container, ".montage-up", function() {
    if (new_container.index() !== 3) {
      return new_container.moveUp();
    }
  });
  do_action_button_with_save(new_container, ".montage-down", function() {
    return new_container.moveDown();
  });
  $(url_target).on("paste", function(e) {
    return setTimeout(function() {
      return $(e.target).trigger('change');
    }, 1);
  });
  new_container.find(".montageEnd, .montageStart").on("paste keydown", function(e) {
    return setTimeout(function() {
      return $(e.target).trigger('change');
    }, 1);
  });
  return url_target;
};

append_new_video_container_if_none_left = function() {
  var last;
  if (montage_link_container) {
    if (montage_link_container.children().length > 3) {
      last = get_link_from_montage_container(montage_link_container.children().last());
      if ((last.val() != null) && last.val().trim().length) {
        return append_new_video_container();
      }
    } else {
      return append_new_video_container();
    }
  }
};

montage_links = {};

montage_link_entered = function(e) {
  var image_target, link_index, link_target, title_target, youtube_id;
  link_index = $(e.target.parentNode.parentNode.parentNode.parentNode).index();
  image_target = $(e.target.parentNode.parentNode.parentNode.parentNode).children(".thumb").first();
  title_target = $(e.target.parentNode.parentNode).children(".montageTitle").first();
  link_target = e.target.value;
  if (montage_links[link_index] === link_target) {
    return;
  } else {
    montage_links[link_index] = link_target;
  }
  youtube_id = yt_link_to_id(link_target);
  if (youtube_id != null) {
    serializeAndSave();
    $(e.target.parentNode).addClass("has-success");
    set_video_image(image_target, link_to_img(youtube_id));
    set_video_title(title_target, youtube_id);
    append_new_video_container_if_none_left();
    return;
  }
  $(e.target.parentNode).removeClass("has-success");
  serializeAndSave();
  clear_video_image(image_target);
  return clear_video_title(title_target);
};

unserialize = function(data) {
  var j, link, number_of_videos, ref, start, stop, video_index;
  if ((data != null) && data !== "") {
    data = data.split(":");
    montage_secret = data[0];
    montage_link_container.find("#montageName").val(data[1]);
    data = data.slice(2);
    number_of_videos = data.length / 3;
  } else {
    data = [];
  }
  if (number_of_videos > 0) {
    for (video_index = j = 0, ref = number_of_videos - 1; 0 <= ref ? j <= ref : j >= ref; video_index = 0 <= ref ? ++j : --j) {
      link = append_new_video_container();
      start = link.parent().parent().find(".montageStart");
      stop = link.parent().parent().find(".montageEnd");
      link.attr("value", youtube_video_link + data[video_index * 3]);
      if (data[video_index * 3 + 1] !== "0") {
        start.attr("value", time_to_text(data[video_index * 3 + 1]));
      }
      if (data[video_index * 3 + 2] !== "0") {
        stop.attr("value", time_to_text(data[video_index * 3 + 2]));
      }
    }
  }
  return montage_link_container.children().each(function(i, container) {
    return get_link_from_montage_container($(container)).trigger('change');
  });
};

serialize = function() {
  var data, montage_name;
  data = [];
  montage_name = get_montage_title();
  data.push(montage_secret);
  data.push(montage_name);
  montage_link_container.children().each(function(i, container) {
    var end_time, link, start, start_time, stop, youtube_id;
    link = get_link_from_montage_container($(container));
    youtube_id = null;
    if ((link != null) && (link.val() != null)) {
      youtube_id = yt_link_to_id(link.val().trim());
    }
    if (youtube_id != null) {
      start = link.parent().parent().find(".montageStart");
      stop = link.parent().parent().find(".montageEnd");
      data.push(youtube_id);
      start_time = 0;
      if ((start.val() != null) && start.val() !== "") {
        start_time = text_to_time(start.val());
        if (start_time > 0) {
          start.parent().addClass("has-success");
        }
        data.push(start_time);
      } else {
        start.parent().removeClass("has-success");
        data.push(0);
      }
      if ((stop.val() != null) && stop.val() !== "") {
        end_time = text_to_time(stop.val());
        if (end_time > 0) {
          if (end_time > start_time) {
            stop.parent().removeClass("has-error");
            stop.parent().addClass("has-success");
          } else {
            end_time = 0;
            stop.parent().removeClass("has-success");
            stop.parent().addClass("has-error");
          }
        } else {
          stop.parent().removeClass("has-error");
          stop.parent().removeClass("has-success");
        }
        return data.push(end_time);
      } else {
        stop.parent().removeClass("has-error");
        stop.parent().removeClass("has-success");
        return data.push(0);
      }
    }
  });
  return data.join(":");
};

update_previous_montages = function(link_data, remove_this_id) {
  var data, date, id, j, k, len, len1, list_location, output, previous_ids, previous_titles, record, record_string, results, title;
  list_location = $("#previous-montages .dest");
  data = window.localStorage.getItem("data");
  if ((data != null) && data !== "") {
    data = data.split("||");
  } else {
    data = [];
  }
  previous_titles = {};
  for (j = 0, len = data.length; j < len; j++) {
    record_string = data[j];
    record = record_string.split(":");
    previous_titles[record[0]] = record[1];
  }
  if (montage_id != null) {
    date = new Date();
    previous_titles["" + montage_id] = (get_montage_title()) + " " + (date.getMonth() + 1) + "/" + (date.getDate()) + "/" + (date.getFullYear());
    if ((link_data != null) && link_data.split(":").length === 2) {
      delete previous_titles["" + montage_id];
    }
    if (remove_this_id) {
      delete previous_titles["" + remove_this_id];
    }
    output = (function() {
      var results;
      results = [];
      for (id in previous_titles) {
        title = previous_titles[id];
        results.push([id, title].join(":"));
      }
      return results;
    })();
    window.localStorage.setItem("data", output.join("||"));
  }
  previous_ids = Object.keys(previous_titles).sort().reverse();
  if (previous_ids.length > 0) {
    list_location.empty();
  }
  results = [];
  for (k = 0, len1 = previous_ids.length; k < len1; k++) {
    id = previous_ids[k];
    list_location.append($("<li><a href='/edit/" + id + "'>" + previous_titles[id] + "</a></li>"));
    if (id + 1 < previous_ids.length) {
      results.push(list_location.append($("<span>,</span>")));
    } else {
      results.push(void 0);
    }
  }
  return results;
};

finishedSerializing = function() {
  var full_url, link_to_montage_html, rel_url;
  rel_url = "" + watch_link + montage_id;
  full_url = "https://radmontage.com" + watch_link + montage_id;
  link_to_montage_html = "<a href=\"" + rel_url + "\" class=\"btn btn-default btn-sm\" id=\"montage-play-button\"><i class=\"fa fa-play\"></i> Play</a>\n<span id=\"montage-manual-link\">\n    Link to share: <a href='" + rel_url + "'>" + full_url + "</a>\n</span>";
  return $("#montage-link").html(link_to_montage_html);
};

last_saved = "";

serializeAndSave = function() {
  var anything_to_save, data;
  if (disable_saving) {
    return;
  }
  data = serialize();
  anything_to_save = (data != null) && data !== "" && data.split(":").length > 2;
  if (anything_to_save && data !== last_saved) {
    $("#montage-link").html("Saving...");
    if ((montage_secret == null) || montage_secret === "") {
      disable_saving = true;
      return $.get(new_endpoint, {}, function(result) {
        disable_saving = false;
        montage_id = result.id;
        montage_secret = result.secret;
        history.replaceState(null, "", "/edit/" + montage_id);
        return serializeAndSave();
      }, 'json');
    }
    if (window.localStorage) {
      window.localStorage.setItem(montage_id, data);
      window.localStorage.setItem("last_worked_on", montage_id);
    }
    if ((montage_secret != null) && montage_secret) {
      $.post(save_endpoint, {
        id: montage_id,
        secret: montage_secret,
        data: data
      }, function() {
        last_saved = data;
        return finishedSerializing();
      }, 'json').fail(function(xhr) {
        if (xhr.status === 403) {
          montage_secret = null;
          update_previous_montages(null, montage_id);
          return serializeAndSave();
        }
      });
    }
  }
  return update_previous_montages(data);
};

$(function() {
  var last_worked_on, saved_data;
  update_previous_montages();
  montage_link_container = $("#montage-links-container");
  if (get_edit_id() != null) {
    montage_id = get_edit_id();
    if (montage_id === "new") {
      montage_id = null;
      window.localStorage.setItem("last_worked_on", "");
    }
  }
  last_worked_on = window.localStorage.getItem("last_worked_on");
  if ((montage_id == null) && (last_worked_on != null) && last_worked_on !== "") {
    montage_id = last_worked_on;
  }
  if (montage_id != null) {
    saved_data = window.localStorage.getItem(montage_id);
    if ((saved_data != null) && saved_data !== "") {
      unserialize(saved_data);
      history.replaceState(null, "", "/edit/" + montage_id);
    } else {
      $.get(get_endpoint, {
        id: montage_id
      }, function(result) {
        unserialize(":" + result.join(":"));
        return serializeAndSave();
      }, 'json');
    }
    append_new_video_container_if_none_left();
  } else {
    append_new_video_container();
  }
  return $("#montageName").change(function() {
    return serializeAndSave();
  });
});
