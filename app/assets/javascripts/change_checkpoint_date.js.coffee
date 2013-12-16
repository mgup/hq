$ ->
  root = $('#matrixHQ').attr('href')
  $('.change_date_buttons').click ->
    $.ajax "#{root}study/disciplines/#{$(this).data('parent')}/checkpoints/#{$(this).data('value')}/change_date"