$ ->
  $('.student-and-person-form[data-type="edit"] input, .student-and-person-form[data-type="edit"] select').prop('disabled', true)

  $('.edit-student-person').click ->
    if $(this).hasClass('active')
      $(this).text('Редактировать')
      $(this).addClass('btn-info')
      $(this).removeClass('btn-danger')
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] input').prop('disabled', true)
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] select').prop('disabled', true)
    else
      $(this).text('Отмена')
      $(this).removeClass('btn-info')
      $(this).addClass('btn-danger')
      $(this).addClass('active')
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] input').prop('disabled', false)
      $('.student-and-person-form[data-value="'+$(this).data('value')+'"] select').prop('disabled', false)