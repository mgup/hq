$ ->
  $('.enroll-link').click ->
    if confirm($(this).data('question'))
      $(this).hide()
      $(this).siblings('.loader').show()