// onload script
function ready_for_fesdy() {
  // fade-in welcome-card
  $('.card.welcome').animate({
    "opacity": "0",
    "margin-top"   : "-2rem"
  }, 0);
  $('.card.welcome').animate({
    "opacity": "1",
    "margin-top"   : "0rem"
  }, 1000);
};
