// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

$(function() {
  // for iPhone
  $('thead').click(function() {});
});

function ready_for_ytpages() {

  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  var player;

}

function onYouTubeIframeAPIReady() {

  var video_id = $('#video-frame').data('video-id');

  player = new YT.Player('video-frame', {
    height: '390',
    width: '640',
    videoId: video_id,
    playerVars:{
      autohide: 0,
      controls: 1,
      showinfo: 0,
      modestbranding: 1,
      rel: 0,
      theme: 'light',
      color: 'white'
    },  
    events: {
      'onReady': onPlayerReady,
     // 'onStateChange': onPlayerStateChange
    }   
  }); 
  
  function onPlayerReady(event) {
    // event.target.playVideo();
  }
/*
 * このコメントアウトを外すとyoutubeも読み込まれなくなった
 *
  function onPlayerStateChange(e) {
    if (e.data == YT.PlayerState.ENDED) {
      playEnd();
    }
    if (e.data == YT.PlayerState.PLAYING) {
      playBtn.hide();
    }
  }

  function playEnd() {
    //再生が終わったら次の曲のidを調べる
    function() {
      $.ajax({
        url: "next_song",
        type: "GET",
        dataType: "html"
      });
    }
    layer.clearVideo();
    
    player.loadVideoById($('#video-frame').data('video-id'));
    player.playVide();
  }
*/

}
