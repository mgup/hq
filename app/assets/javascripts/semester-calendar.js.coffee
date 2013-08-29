$ ->
  $('.lecture_fields .date').each (index, el) ->
    $('.lectures .semester-calendar td[data-date="' + $(el).val() + '"]').addClass('success')

  $(document).on 'nested:fieldAdded:lectures', (event) ->
    date_field = event.field.find('.date')
    date_field.val($(event.link).attr('data-date')).attr('data-date', $(event.link).attr('data-date'))

  $('.lectures .day').click ->
    $this = $(this)
    if $this.hasClass('success')
      date = $this.attr('data-date')
      if ($('.lectures input[data-date="' + date + '"]').length > 0)
        $field = $($('.lectures input[data-date="' + date + '"]'))
      else
        $field = $($('.lectures input[value="' + date + '"]'))
      $field.parents('.lecture_fields').children('.remove_nested_fields').click()
    else
      $link = $($('a[data-blueprint-id="lectures_fields_blueprint"]')[0])
      $link.attr('data-date', $this.attr('data-date'))
      $link.click()
    $this.toggleClass('success')






  $('.checkpoint_fields .date').each (index, el) ->
    $('.checkpoints .semester-calendar td[data-date="' + $(el).val() + '"]').addClass('success')

  $(document).on 'nested:fieldAdded:checkpoints', (event) ->
    date_field = event.field.find('.date')
    date_field.val($(event.link).attr('data-date')).attr('data-date', $(event.link).attr('data-date'))

  $('.checkpoints .day').click ->
    $this = $(this)
    if $this.hasClass('success')
      date = $this.attr('data-date')
      if ($('.checkpoint_fields input[data-date="' + date + '"]').length > 0)
        $field = $($('.checkpoint_fields input[data-date="' + date + '"]'))
      else
        $field = $($('.checkpoint_fields input[value="' + date + '"]'))
      $field.parents('.checkpoint_fields').children('.remove_nested_fields').click()
    else
      $link = $($('a[data-blueprint-id="checkpoints_fields_blueprint"]')[0])
      $link.attr('data-date', $this.attr('data-date'))
      $link.click()
    $this.toggleClass('success')