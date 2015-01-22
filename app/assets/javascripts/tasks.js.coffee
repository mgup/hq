$ ->
  $('#curatorAlert').hide()
  $('#checkAllCurators').click ->
    if $(this).hasClass('checked')
      $(this).removeClass('checked')
      $('.curatorCheckbox').each ->
        $(this).prop('checked', false).prop('readonly', false)
    else
      $(this).addClass('checked')
      $('.curatorCheckbox').each ->
        $(this).prop('checked', true).prop('readonly', true)

  $('.curatorCheckbox').click ->
    key = true
    $('.curatorCheckbox').each ->
      key = $(this).prop('checked')*key
    if key
      $('#checkAllCurators').prop('checked', true).addClass('checked')
    else
      $('#checkAllCurators').prop('checked', false).removeClass('checked')

  $('.task_user_check').click ->
    if this.checked
      $('.task_user_check').each ->
        this.checked = null
      this.checked = true
    $('#curators-filters').submit()

#  $('#taskFormSubmit').click (e) ->
#    key = false
#    $('.curatorCheckbox').each ->
#      key = $(this).prop('checked')+key
#    if key
#      $('#curatorAlert').hide()
#    else
#      $('#curatorAlert').show()
#      e.preventDefault()