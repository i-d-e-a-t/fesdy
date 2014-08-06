// onload script
function ready_for_festival() {
  // for iPhone
  // TODO なぜかクリックイベントを登録しないと、
  // 別画面から遷移した時リンクが効かない。
  $('thead').click(function() {});

  // fade-in eyecatch image
  $('.eye-catch').fadeOut(0).fadeIn('slow');
  // fade-in & slide-in festival information
  $('.fes .info-box').animate({"opacity": "-=1", "top": "-=3rem"}, 0);
  setTimeout(function() {
    $('.fes .info-box').animate({"opacity": "+=1", "top": "+=3rem"}, 'slow');
  }, 500);

  // when button.to-top clicked
  $('button.to-top').click(function() {
    $('body, html').animate(
      {scrollTop: 0},
      // 0.5sec
      500
    );
    return false;
  });
};
