$ ->
  $('.show_event_dates #event_date_date').each (index, element) ->
    text = $('.events .semester-calendar td[data-date="' + $(element).val() + '"]').text()
    $('.events .semester-calendar td[data-date="' + $(element).val() + '"]').addClass($(element).data('value'))
          .html("<a data-toggle='modal' href='#dateBook#{index+1}'>#{text}</a>")
    if $(element).data('select') == 'selected'
      $('.events .semester-calendar td[data-date="' + $(element).val() + '"]').addClass('selected')

  $('.dates-for-events').each (index, element) ->
    text = $('.actuals .semester-calendar td[data-date="' + $(element).val() + '"]').text()
    $('.actuals .semester-calendar td[data-date="' + $(element).val() + '"]').html("<a data-toggle='modal' href='#dateEvents#{index+1}'>#{text}</a>")

  $('.event_dates #event_date_date').each (index, element) ->
    $('.event_dates .semester-calendar td[data-date="' + $(element).val() + '"]').addClass($(element).data('value'))

  $('.event_dates .semester-calendar td').click ->
    $('#accordionDates a[data-date="' + $(this).attr('data-date') + '"]').click()
    $('html, body').animate({
      scrollTop: $($('#accordionDates a[data-date="' + $(this).attr('data-date') + '"]').attr('href')).offset().top - 150
    }, 2000);


