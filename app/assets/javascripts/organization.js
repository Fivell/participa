//= require pure.side.menu
//
$(function(){

  if ( $('.js-header-others-show').length > 0 ){
    $('.js-header-others-show').on('click', function(e) {
      e.preventDefault();
      $('.js-header-others-hidden').removeClass('hide').show();
      $('.menu ul').animate({padding: '5px 0px 0px'});
    });
  }

});
