$ ->
  root = $('#matrixHQ').attr('href')
  all_causes = []
  $('.support_check').click ->
    if this.checked
      $('.support_check').each ->
        this.checked = null
      this.checked = true

  $('.support_reasons').click ->
    causes = []
    $('.support_reasons').each ->
      if this.checked
        causes.push $(this).val()
    all_causes = causes

  $('#supportPreventModal').click (e) ->
    e.preventDefault()
    $.ajax "#{root}students/#{$('#my_support_support_student').val()}/supports/options?causes=#{all_causes}"
