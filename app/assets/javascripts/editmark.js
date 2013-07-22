$(function() {
    $('.mark-editor').click( function () {
      var $this = $(this);
      var $student =  $this.data('value');
      $('#check_result_' + $student).css({ 'display': 'block' });
    });
});