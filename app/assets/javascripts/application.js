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

function ready_for_itunes_search() {
  var artistId = $('#itunes_search_id').val();
  $.get('/artists/' + artistId + '/itunes', null, function(data) {
    $('#itunes').html(data);
  });
}

function ready_for_ytpages() {

  // youtube API が作成したjsをリセット
  YT = null;

  // youtube API のロード
  var ytIframeApiUrl  = "https://www.youtube.com/iframe_api";
  var tag = $('<script>', {id: 'youtube-iframe-api', src: ytIframeApiUrl});
  $('head').append(tag);

}

function onYouTubeIframeAPIReady() {

  var video_id = $('#video-frame').data('video-id');
 
  // autoplayするかどうかは<input id="autoplay" type="hidden" name="autoplay">に保持。
  //   yes...自動再生
  //   それ以外...自動再生しない
  // 1曲目再生時は自動再生を行わない。
  // 2曲目以降は自動再生を行う。
  var autoplay = 0;
  if ($('#autoplay').val() == "yes") {
    autoplay = 1;
  }

  var player = new YT.Player('video-frame', {
    height: '390',
    width: '640',
    videoId: video_id,
    playerVars:{
      autoplay: autoplay,
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
      'onStateChange': onPlayerStateChange,
    }   
  });
  
  function onPlayerReady(event) {
    // event.target.playVideo();
  }

  function onPlayerStateChange(e) {
    // 再生終了時にリロード
    // TODO: ajax
    state = e.data;
    if (state == 0) {
      movieEnd();
    }
  }

  // 再生完了時の処理
  function movieEnd() {
    // 次の曲へ
    nextStudy();
  }

}

function nextStudy() {
  // 次の曲へ。
  // TODO 今はリロードだが、ajax化したい
  location.reload();
}
