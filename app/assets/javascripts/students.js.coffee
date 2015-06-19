$ ->
  $('.student-and-person-form[data-type="edit"] input, .student-and-person-form[data-type="edit"] select').not('.name_field').prop('disabled', true)

  $('.edit-student-person').click ->
    if $(this).hasClass('active')
      $(this).text('Редактировать')
      $(this).addClass('btn-info')
      $(this).removeClass('btn-danger')
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] input').not('.name_field').prop('disabled', true)
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] select').not('.name_field').prop('disabled', true)
    else
      $(this).text('Отмена')
      $(this).removeClass('btn-info')
      $(this).addClass('btn-danger')
      $(this).addClass('active')
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] input').not('.name_field').prop('disabled', false)
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] select').not('.name_field').prop('disabled', false)

  $('#show_archive_documents').click ->
    $('#archive_documents_table').toggle()
