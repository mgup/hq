$ ->
    $(document).on('nested:fieldAdded', (event) ->
      field = event.field
      dateField = field.find('.datepicker')
      dateField.datepicker()
    )
