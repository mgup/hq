$ ->
  $screen_position = 0
  $('#return_up').click ->
    if $(this).find('span').hasClass('glyphicon-chevron-up')
      $screen_position = $(window).scrollTop()
      $('body').animate({
        scrollTop: $('body').offset().top
      }, 1000)
    else
      $('body').animate({
        scrollTop: $screen_position
      }, 1000)


  $(window).on 'scroll':->
    if $(this).scrollTop() > 100
      $('#return_up span').addClass('glyphicon-chevron-up').removeClass('glyphicon-chevron-down')
    else
      $('#return_up span').addClass('glyphicon-chevron-down').removeClass('glyphicon-chevron-up')
