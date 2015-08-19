// Generated by CoffeeScript 1.9.3
var get_currently_playing_id, get_video_end, get_video_start, get_video_url, iOS, if_zero_return_null, onPlayerReady, onPlayerReady2, onPlayerStateChange, onPlayerStateChange2, onYouTubeIframeAPIReady, player_index, players, ready, testCardImageBasePath, toggleFullScreen, toggle_player_index, video_end, videos;

videos = window.videos;

players = [];

player_index = 0;

iOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;

ready = [false, false];

testCardImageBasePath = "https://d12gd74eaa9d1v.cloudfront.net/";

toggleFullScreen = function() {
  if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {
    if (document.documentElement.requestFullscreen) {
      return document.documentElement.requestFullscreen();
    } else if (document.documentElement.msRequestFullscreen) {
      return document.documentElement.msRequestFullscreen();
    } else if (document.documentElement.mozRequestFullScreen) {
      return document.documentElement.mozRequestFullScreen();
    } else if (document.documentElement.webkitRequestFullscreen) {
      return document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
    }
  } else {
    if (document.exitFullscreen) {
      return document.exitFullscreen();
    } else if (document.msExitFullscreen) {
      return document.msExitFullscreen();
    } else if (document.mozCancelFullScreen) {
      return document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) {
      return document.webkitExitFullscreen();
    }
  }
};

onYouTubeIframeAPIReady = function() {
  return $(function() {
    players.push(new YT.Player('player', {
      playerVars: {
        iv_load_policy: 3
      },
      events: {
        onReady: function() {
          return onPlayerReady();
        },
        onStateChange: function(e) {
          return onPlayerStateChange(e);
        }
      }
    }));
    return players.push(new YT.Player('player2', {
      playerVars: {
        iv_load_policy: 3
      },
      events: {
        onReady: function() {
          return onPlayerReady2();
        },
        onStateChange: function(e) {
          return onPlayerStateChange2(e);
        },
        onError: function(e) {
          return console.log(e);
        }
      }
    }));
  });
};

onPlayerReady = function() {
  return ready[0] = true;
};

onPlayerStateChange = function() {};

onPlayerReady2 = function() {
  return ready[1] = true;
};

onPlayerStateChange2 = function() {};

get_currently_playing_id = function() {
  if (player_index === 0) {
    return 1;
  } else {
    return 0;
  }
};

toggle_player_index = function() {
  return player_index = get_currently_playing_id();
};

if_zero_return_null = function(i) {
  if (i === 0) {
    return null;
  } else {
    return parseInt(i);
  }
};

get_video_url = function(videos, video_index) {
  return videos[3 * video_index];
};

get_video_start = function(videos, video_index) {
  return if_zero_return_null(videos[3 * video_index + 1]);
};

get_video_end = function(videos, video_index) {
  return if_zero_return_null(videos[3 * video_index + 2]);
};

video_end = function(container, end_splash) {
  $("body").addClass("video-done");
  $("html").addClass("video-done");
  container.hide();
  container.remove();
  end_splash.show();
  if (iOS) {
    $('.adsbygoogle').hide();
    return $('ios_code').appendTo($("head"));
  } else {
    return (window.adsbygoogle || []).push({});
  }
};

$(function() {
  var click_movie_function, container, end_splash, instructions, need_to_show_instructions, not_end_of_videos, player_html, startTick, stopTick, timer, video_index;
  instructions = $("#instructions");
  need_to_show_instructions = true;
  container = $('#container');
  end_splash = $('#end-splash');
  player_html = void 0;
  video_index = 0;
  videos = videos.slice(1);
  not_end_of_videos = function() {
    return video_index < (videos.length / 3);
  };
  timer = null;
  startTick = function() {
    var current_player, end_time, next_tick_skips, tick, timeout_time;
    current_player = players[get_currently_playing_id()];
    if ((get_video_end(videos, video_index - 1) != null) && get_video_end(videos, video_index - 1) !== 0) {
      end_time = get_video_end(videos, video_index - 1);
    } else {
      end_time = current_player.getDuration();
    }
    timeout_time = 900;
    next_tick_skips = false;
    tick = function() {
      return timer = setTimeout(function() {
        var current_time;
        current_time = current_player.getCurrentTime();
        if (next_tick_skips) {
          return click_movie_function();
        } else if ((timeout_time === 900) && current_time + 1.5 > end_time) {
          timeout_time = 50;
          return tick();
        } else if (current_time + .5 > end_time) {
          timeout_time = Math.floor((end_time - current_time - .1) * 1000);
          next_tick_skips = true;
          tick();
          players[player_index].playVideo();
          return setTimeout(function() {
            return players[player_index].pauseVideo();
          }, 100);
        } else {
          return tick();
        }
      }, timeout_time);
    };
    return tick();
  };
  stopTick = function() {
    return clearTimeout(timer);
  };
  click_movie_function = function() {
    if (not_end_of_videos()) {
      if (video_index === 0) {
        players[player_index].loadVideoById({
          videoId: get_video_url(videos, video_index),
          startSeconds: get_video_start(videos, video_index),
          endSeconds: get_video_end(videos, video_index),
          suggestedQuality: 'default'
        });
      }
      player_html[player_index].css('z-index', 2);
      player_html[player_index].css('visibility', 'visible');
      players[player_index].playVideo();
      toggle_player_index();
      player_html[player_index].css('z-index', 1);
      player_html[player_index].css('visibility', 'hidden');
      video_index += 1;
      if (not_end_of_videos()) {
        players[player_index].loadVideoById({
          videoId: get_video_url(videos, video_index),
          startSeconds: get_video_start(videos, video_index),
          endSeconds: get_video_end(videos, video_index),
          suggestedQuality: 'default'
        });
        return players[player_index].pauseVideo();
      } else {
        return players[player_index].stopVideo();
      }
    } else {
      players[0].stopVideo();
      players[1].stopVideo();
      document.onmousemove = null;
      return video_end(container, end_splash);
    }
  };
  window.click_movie_function = click_movie_function;
  window.previous_movie_function = function() {
    if (video_index === 1) {
      if (get_video_start(videos, 0) != null) {
        return players[get_currently_playing_id()].seekTo(get_video_start(videos, 0));
      } else {
        return players[get_currently_playing_id()].seekTo(0);
      }
    } else {
      players[0].pauseVideo();
      players[1].pauseVideo();
      video_index -= 2;
      players[player_index].loadVideoById({
        videoId: get_video_url(videos, video_index),
        startSeconds: get_video_start(videos, video_index),
        endSeconds: get_video_end(videos, video_index),
        suggestedQuality: 'default'
      });
      return click_movie_function();
    }
  };
  window.play_pause_movie_function = function() {
    var player;
    player = players[get_currently_playing_id()];
    if (player.getPlayerState() === YT.PlayerState.PLAYING) {
      return player.pauseVideo();
    } else if (player.getPlayerState() === YT.PlayerState.PAUSED) {
      return player.playVideo();
    }
  };
  onPlayerStateChange = function(event) {
    if (get_currently_playing_id() === 0) {
      stopTick();
      if (event.data === YT.PlayerState.PLAYING) {
        startTick();
        if (need_to_show_instructions && !iOS) {
          need_to_show_instructions = false;
          instructions.show();
          return window.setTimeout(function() {
            return instructions.fadeOut(500);
          }, 2500);
        }
      } else if (event.data === YT.PlayerState.ENDED) {
        return click_movie_function();
      }
    }
  };
  onPlayerStateChange2 = function(event) {
    if (get_currently_playing_id() === 1) {
      stopTick();
      if (event.data === YT.PlayerState.PLAYING) {
        return startTick();
      } else if (event.data === YT.PlayerState.ENDED) {
        return click_movie_function();
      }
    }
  };
  if (ready[0] && ready[1]) {
    return click_movie_function();
  } else {
    onPlayerReady = function() {
      ready[0] = true;
      if (ready[0] && ready[1]) {
        player_html = [$("#player"), $("#player2")];
        return click_movie_function();
      }
    };
    return onPlayerReady2 = function() {
      ready[1] = true;
      if (ready[0] && ready[1]) {
        player_html = [$("#player"), $("#player2")];
        return click_movie_function();
      }
    };
  }
});
