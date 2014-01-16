$ ->
  $('.changeMaxVisitors').click ->
  	$(this).text(if $(this).text() == 'Изменить число мест' then 'Оставить прежним' else 'Изменить число мест')
  	$("#changeMaxVisitors#{$(this).data('value')}").toggle()
  $('.addVisitor').click ->
    $(this).text(if $(this).text() == 'Добавить сотрудника' then 'Отмена' else 'Добавить сотрудника')
    $("#addVisitor#{$(this).data('value')}").toggle()