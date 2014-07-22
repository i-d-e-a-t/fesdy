$(function() {
  // 画面描画完了時の処理

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
