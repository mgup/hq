$ ->
  $('.changeMaxVisitors').click ->
  	$(this).text(if $(this).text() == 'Изменить число мест' then 'Оставить прежним' else 'Изменить число мест')
  	$("#changeMaxVisitors#{$(this).data('value')}").toggle()