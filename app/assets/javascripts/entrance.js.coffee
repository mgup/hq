$ ->
  $('.enroll-link').click ->
    if confirm($(this).data('question'))
      $(this).hide()
      $(this).siblings('.loader').show()

  $('.medical-disability-kind-select').change ->
    if this.value == 'medical'
      $('.disability-select').prop( 'disabled', true )
    else
      $('.disability-select').prop( 'disabled', false )

  $('#benefit_reason').change ->
    $('.entrance_benefit_document').hide()
    $('.entrance_benefit_document').find('input, textarea, button, select').prop('disabled', true)
    $('#entrant_benefit_' + this.value + '_document').show()
    $('#entrant_benefit_' + this.value + '_document').find('input, textarea, button, select').prop( 'disabled', false)
    $('.medical-disability-kind-select').change()

  $('#benefit_reason').change()
	  
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
