$ ->
  $('.enroll-link').click ->
    if confirm($(this).data('question'))
      $(this).hide()
      $(this).siblings('.loader').show()
	  
	  
  $(document).on "nested:fieldAdded", (event) ->
    field = event.field
    dateField = field.find(".datepicker")

    dateField.datepicker({
      format: 'dd.mm.yyyy'
      language: 'ru-RU'
    })


    $(document).ready datepicker_update = ->
      $(".datepicker").datepicker({
        format: 'dd.mm.yyyy'
        language: 'ru-RU'
      })