$ ->
  root = $('#matrixHQ').attr('href')
  $('.editMarkField').hide()
  $('body').on 'click', '.editMarkButton', (e) ->
    e.preventDefault()
    btn = $(this)
    btn.parents('tr').find('.editMarkField').show()
    btn.text('Сохранить');
    btn.addClass('btn-success')

    btn.click ->
      mark = $(this).parents('tr').find('.mark_id').val()
      value = if $(this).parents('table').data('value') == 3 then parseInt($(this).parents('tr').find('.value').val()) else $(this).parents('tr').find('label.active').find('input').val()
      condition = if $(this).parents('table').data('value') == 3 then ( value >= 0 && value <= parseInt($('body').find('.maxValue').text())) else true
      if condition
        $.getJSON ($('form.marks').attr('action') + '/marks/' + mark + '/ajax_update'),{
          'mark': value
        }, (mark) ->
          btn.parents('tr').removeClass('warning')
          span = btn.parents('tr').find('.editMarkField').parent().find('span')
          btn.parents('tr').find('.editMarkField').parent().find('p').empty()
          span.empty()
          span.text(mark.result)
          span.attr('class', "label label-#{mark.color}")
          btn.parents('tr').find('.editMarkField').hide()
          btn.parents('tr').find('.mark_id').val(mark.id)
          td = btn.parent()
          td.empty()
          td.html('<button class="btn-default btn editMarkButton">Редактировать</button>')
      else
        val = $(this).parents('tr').find('.value')
        val.val(val.attr('value'))
        $(this).parents('tr').addClass('warning')
        btn.parents('tr').find('.editMarkField').hide()
        btn.parents('tr').find('.editMarkField').parent().find('span').parent().append($('<p class="text-danger">Вы пытались ввести некорректное значение</p>'))
        td = btn.parent()
        td.empty()
        td.html('<button class="btn-default btn editMarkButton">Редактировать</button>')

  $('#formForMarks').submit (e) ->
    if $(this).find('table').data('value') == 3
      key = true
      $('.value').each ->
        input = $(this)
        if input.val() != ''
          key = key && (parseInt(input.val()) >= 0 && parseInt(input.val()) <= parseInt($('body').find('.maxValue').text()))
          if isNaN(input.val()*1)
            key = false
      unless key
        e.preventDefault()
        $('body').find('.alert-warning').show()
        $('body').animate({
          scrollTop: $(this).offset().top
        }, 2000)