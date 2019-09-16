//= require jquery3
//= require popper
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

$(document).on('ready turbolinks:load', function(){
  $("#menu-toggle").click(function(e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
  });

  window.fbAsyncInit = function() {
    FB.init({
      appId            : '471690367017070',
      autoLogAppEvents : true,
      xfbml            : true,
      version          : 'v4.0'
    });
  };

  $.getScript('https://connect.facebook.net/en_US/sdk.js')

})
