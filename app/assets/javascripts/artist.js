// onload script

function ready_for_artist(){

  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  var player;

}

function onYouTubeIframeAPIReady() {

  var video_id = $('#video-frame').data('video-id');
  console.log('video-id = ' + video_id)

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
}


