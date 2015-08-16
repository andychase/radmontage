// Generated by CoffeeScript 1.9.3
(function() {
  var init;
  $.fn.slideview = function(slides, settings) {
    return this.each(function() {
      return init(this, slides, settings);
    });
  };
  return init = function(element, slides, settings) {
    var $container, $viewport, el, i, size;
    if ($.isFunction(slides)) {
      slides = slides(element);
    }
    size = settings.size || 300;
    $viewport = $(element).css({
      overflow: 'hidden'
    }).addClass('slideview-viewport').empty();
    $container = $('<div></div>');
    $container.css({
      overflow: 'hidden',
      margin: 0,
      padding: 0,
      border: 0,
      position: 'relative',
      width: size * slides.length + 'px'
    });
    $container.addClass('slideview-container');
    $container.appendTo($viewport);
    for (i in slides) {
      el = $("<div><img src='" + slides[i] + "' alt='' style='width: 320px; height: 180px;'/></div>");
      el.css({
        margin: 0,
        padding: 0,
        width: size + 'px',
        overflow: 'hidden',
        'float': 'left',
        border: 0
      });
      el.addClass('slideview-slide');
      el.appendTo($container);
    }
    return $viewport.bind('mousemove', function(evt) {
      var offset, x;
      x = Math.max(1, evt.offsetX);
      offset = Math.floor(x / (size / slides.length)) * size;
      $container.css('right', offset);
      return false;
    });
  };
})();

$(function() {
  var fullscreen, iframe, play_pause, skip, to_img;
  if (window.montage_images != null) {
    to_img = function(id) {
      return "https://i.ytimg.com/vi/" + id + "/mqdefault.jpg";
    };
    $('.explore-video-thumb').slideview((function(element) {
      var id, j, len, ref, results;
      if (window.montage_images[element.id] != null) {
        ref = window.montage_images[element.id];
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          id = ref[j];
          results.push(to_img(id));
        }
        return results;
      }
    }), {
      size: 320
    });
  }
  iframe = $("#watch-video-iframe");
  if (iframe != null) {
    fullscreen = function() {
      return iframe[0].contentWindow.toggleFullScreen();
    };
    play_pause = function() {
      return iframe[0].contentWindow.play_pause_movie_function();
    };
    skip = function() {
      return iframe[0].contentWindow.click_movie_function();
    };
    $("#watch-control-fullscreen").click(function() {
      return fullscreen();
    });
    $("#watch-control-play-pause").click(function() {
      return play_pause();
    });
    return $("#watch-control-skip").click(function() {
      return skip();
    });
  }
});
