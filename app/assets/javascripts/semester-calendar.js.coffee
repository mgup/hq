$ ->
  # Лекции
  $('.lecture_fields .date').each (index, el) ->
    if 'disabled' == $(el).attr('disabled')
      $('.lectures .semester-calendar td[data-date="' + $(el).val() + '"]').addClass('danger')
    else
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



  # Практические и лабораторные занятия
  $('.seminar_fields .date').each (index, el) ->
    if 'disabled' == $(el).attr('disabled')
      $('.seminars .semester-calendar td[data-date="' + $(el).val() + '"]').addClass('danger')
    else
      $('.seminars .semester-calendar td[data-date="' + $(el).val() + '"]').addClass('success')

  $(document).on 'nested:fieldAdded:seminars', (event) ->
    date_field = event.field.find('.date')
    date_field.val($(event.link).attr('data-date')).attr('data-date', $(event.link).attr('data-date'))

  $('.seminars .day').click ->
    $this = $(this)
    if $this.hasClass('success')
      date = $this.attr('data-date')
      if ($('.seminars input[data-date="' + date + '"]').length > 0)
        $field = $($('.seminars input[data-date="' + date + '"]'))
      else
        $field = $($('.seminars input[value="' + date + '"]'))
      $field.parents('.seminar_fields').children('.remove_nested_fields').click()
    else
      $link = $($('a[data-blueprint-id="seminars_fields_blueprint"]')[0])
      $link.attr('data-date', $this.attr('data-date'))
      $link.click()
    $this.toggleClass('success')



  # Контрольные точки
  $('.checkpoint_fields .date').each (index, el) ->
    if 'disabled' == $(el).attr('disabled')
      $('.checkpoints .semester-calendar td[data-date="' + $(el).val() + '"]').addClass('danger')
    else
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