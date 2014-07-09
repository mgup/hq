$ ->
  $('input[type="radio"][name="entrance_contract[sides]"]').change ->
    if $(this).val() == 'trilateral'
      $(this).closest('.form-group').next('.delegate_information').show()
      $(this).closest('.form-group').next('.delegate_information').find('input').prop('disabled', false)
    else
      $(this).closest('.form-group').next('.delegate_information').hide()
      $(this).closest('.form-group').next('.delegate_information').find('input').prop('disabled', true)
