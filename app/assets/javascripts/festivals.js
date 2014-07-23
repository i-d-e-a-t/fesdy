$(function() {
  // 画面描画完了時の処理
  // アイキャッチ画像のフェードイン
  $('.eye-catch').fadeOut(0).fadeIn('slow');
  // フェス情報がふわっと登場する
  $('.fes .info-box').animate({"opacity": "-=1", "top": "-=3rem"}, 0);
  setTimeout(function() {
    $('.fes .info-box').animate({"opacity": "+=1", "top": "+=3rem"}, 'slow');
  }, 500);

  // button.to-topをクリックすると上に戻る
  $('button.to-top').click(function() {
    $('body, html').animate(
      {scrollTop: 0},
      // 0.5秒
      500
    );
    return false;
  });
});
