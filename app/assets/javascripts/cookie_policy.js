jQuery(function($) {
  $('#close_cookie').on('click', function(evt) {
    evt.preventDefault();
    var expiration = new Date();
    expiration.setFullYear(expiration.getFullYear() + 20);
    document.cookie = 'cookiepolicy=hide' +
                      '; expires=' + expiration.toGMTString() +
                      '; path=/';
    $(this).parent().hide();
  });
});
