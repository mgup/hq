$ ->

  $('.discipline_exams_variants[data-type="1"]').each ->
    if $(this).prop('checked')
      $(this).closest('form').find('.discipline_exams_variants[data-type="1"]').prop('disabled', true)
      $(this).prop('disabled', false)
      $(this).closest('form').find('.fields .exam-type[value="' +  $(this).val() + '"][data-parent="0"]').parents('.fields').appendTo($(this).parent().next('.for-exam'))
      if $(this).data('type') == 1
        $(this).parent().next('.for-exam').find('.exam-weight').show()

  $('.discipline_exams_variants[data-type="1"]').click ->
    if $(this).prop('checked')
      $(this).closest('form').find('.discipline_exams_variants[data-type="1"]').prop('disabled', true)
      $(this).prop('disabled', false)
    else
      $(this).closest('form').find('.discipline_exams_variants[data-type="1"]').prop('disabled', false)

  $('.discipline_exams_variants').click ->
    $this = $(this)
    if $this.prop('checked')
      $link = $(this).closest('form').find('a[data-blueprint-id="exams_fields_blueprint"]')
      $link.attr('data-value', $this.val()).attr('data-type', $this.data('type'))
      $link.click()
      $(this).closest('form').find('.fields .exam-type[value="' +  $this.val() + '"][data-parent="0"]').closest('.fields').appendTo($this.parent().next('.for-exam'))
    else
      $field = $(this).closest('form').find('.fields .exam-type[value="' + $this.val() + '"][data-parent="0"]')
      $field.parents('.discipline_exams_fields').children('.remove_nested_fields').click()

  $(document).on 'nested:fieldAdded:exams', (event) ->
    exam_field = event.field.find('.exam-type')
    type = $(event.link).attr('data-type')
    exam_field.val($(event.link).attr('data-value'))
    if type == '1'
      exam_field.parents('.discipline_exams_fields').find('.exam-weight').show()