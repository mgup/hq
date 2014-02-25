$ ->
  $('.changeMaxVisitors').click ->
  	$(this).text(if $(this).text() == 'Изменить число мест' then 'Оставить прежним' else 'Изменить число мест')
  	$("#changeMaxVisitors#{$(this).data('value')}").toggle()
  $('.addVisitor').click ->
    $(this).text(if $(this).text() == 'Добавить сотрудника' then 'Отмена' else 'Добавить сотрудника')
    $("#addVisitor#{$(this).data('value')}").toggle()

  $('#printDates').click ->
    dates = []
    $('.dateCheckbox').each ->
      if $(this).prop("checked") == true
        dates.push($(this).val())
    window.location.href = "/events/#{$(this).data('value')}/print.pdf?dates=#{dates}"
    $('.dateCheckbox').prop("checked", false)
    $('#printDifferentDates').modal('hide')

  $('.pill-inputs').each ->
    $('.pill-select a[data-value='+$(this).val()+']').tab('show')

  $('.updateListOfClaims').change ->
    $('.claims-filters').submit()
