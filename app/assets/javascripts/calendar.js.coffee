$ ->
  $('.show_event_dates #event_date_date').each (index, element) ->
    text = $('.events .semester-calendar td[data-date="' + $(element).val() + '"]').text()
    $('.events .semester-calendar td[data-date="' + $(element).val() + '"]').addClass($(element).data('value'))
          .html("<a data-toggle='modal' href='#dateBook#{index+1}'>#{text}</a>")
    if $(element).data('select') == 'selected'
      $('.events .semester-calendar td[data-date="' + $(element).val() + '"]').addClass('selected')

  $('.dates-for-events').each (index, element) ->
    text = $('.actuals .semester-calendar td[data-date="' + $(element).val() + '"]').text()
    $('.actuals .semester-calendar td[data-date="' + $(element).val() + '"]').html("<a href='#{$('.actuals .semester-calendar').data('url')}?opened=1&month=#{$(element).data('month')}&year=#{$(element).data('year')}&day=#{text}'>#{text}</a>")

  $('.event_dates #event_date_date').each (index, element) ->
    $('.event_dates .semester-calendar td[data-date="' + $(element).val() + '"]').addClass($(element).data('value'))

  $('.event_dates .semester-calendar td').click ->
    $('#accordionDates a[data-date="' + $(this).attr('data-date') + '"]').click()
    $('html, body').animate({
      scrollTop: $($('#accordionDates a[data-date="' + $(this).attr('data-date') + '"]').attr('href')).offset().top - 150
    }, 2000);

  root = $('#matrixHQ').attr('href')
  $('.previousMonth').click ->
    $.ajax "#{root}events/calendar?year=#{$(this).data('year')}&month=#{$(this).data('month')}&href=#{if $('.actuals .semester-calendar').data('url') == '/events' then '1' else '2'}"
  $('.nextMonth').click ->
    $.ajax "#{root}events/calendar?year=#{$(this).data('year')}&month=#{$(this).data('month')}&href=#{if $('.actuals .semester-calendar').data('url') == '/events' then '1' else '2'}"

  if $('.simple-calendar').parent().find('.open-calendar').hasClass('closed')
    $('.simple-calendar').hide()
  else
    $('.simple-calendar').parent().find('.open-calendar').html('<span class="glyphicon glyphicon-remove"></span>').addClass('btn-sm pull-right')
  $('.open-calendar').click ->
   $(this).parent().find('.simple-calendar').toggle()
   if $(this).hasClass('closed')
     $(this).html('<span class="glyphicon glyphicon-remove"></span>').addClass('btn-sm pull-right').removeClass('closed')
   else
     $(this).html('<span class="glyphicon glyphicon-search"></span> Поиск по дате').removeClass('btn-sm pull-right').addClass('closed')



