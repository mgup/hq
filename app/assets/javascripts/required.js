$(function() {
  $('#notice').css({ 'display': 'none' });
  $('#submit-req').click( function () {
    var $x = $('.required');
    var $key = true;
    $x.each (function () {
      $key *= (this.value != '')
    })
    if (!$key){
      $('#notice').css({ 'display': 'block' }); 
      $(window).scrollTop(0);
    }
  });
});