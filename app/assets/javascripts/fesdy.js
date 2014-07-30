// onload script
function ready_for_fesdy() {
  // fade in
  $(".card").each(function(index) {
    $(this).fadeOut(0);
    $(this).delay(200*index).fadeIn(300);
  });

  // 閉じるボタンにイベント登録
  $(".card-close").click(function() {
    $("#welcome").remove();
  });
};
