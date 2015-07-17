$ ->
  root = $('#matrixHQ').attr('href')
  $('.editResultFields').hide()
  $('body').on 'click', '.editResultButton', (e) ->
    e.preventDefault()
    btn = $(this)
    btn.parents('tr').find('.editResultFields').show()
    btn.text('Сохранить')
    btn.addClass('btn-success')

    btn.click ->
      res = parseInt($(this).parents('tr').find('.score').val())
      if (res >= 0 && res <= 100)
        $.getJSON ($('form.exam_results').attr('action') + '/exam_results/' + $(this).parents('tr').find('.exam_result_id').val() + '/ajax_update'),{
          'result': res
        }, (result) ->
          btn.parents('tr').removeClass('warning')
          span = btn.parents('tr').find('.editResultFields').parent().find('span')
          btn.parents('tr').find('.editResultFields').parent().find('p').empty()
          span.empty()
          span.text(result.score)
          btn.parents('tr').find('.editResultFields').hide()
          td = btn.parent()
          td.empty()
          td.html('<button class="btn-default btn editResultButton">Редактировать</button>')
      else
        val = $(this).parents('tr').find('.score')
        val.val(val.attr('value'))
        $(this).parents('tr').addClass('warning')
        btn.parents('tr').find('.editResultFields').hide()
        btn.parents('tr').find('.editResultFields').parent().find('span').parent().append($('<p class="text-danger">Вы пытались ввести некорректное значение</p>'))
        td = btn.parent()
        td.empty()
        td.html('<button class="btn-default btn editResultButton">Редактировать</button>')

  $('#formForVIResults').submit (e) ->
    key = true
    $('.score').each ->
      input = $(this)
      if input.val() != ''
        key = key && (parseInt(input.val()) >= 0 && parseInt(input.val()) <= 100)
        if isNaN(input.val()*1)
          key = false
    unless key
      e.preventDefault()
      $('body').find('.alert-warning').show()
      $('body').animate({ scrollTop: $(this).offset().top}, 2000)

  $('.editEntranceAchievement').hide()
  $('body').on 'click', '.editEntranceAchievementButton', (e) ->
    e.preventDefault()
    btn = $(this)
    btn.parents('tr').find('.editEntranceAchievement').show()
    btn.text('Сохранить')
    btn.addClass('btn-success')

    btn.click ->
      res = parseInt($(this).parent().parent('tr').find('.score').val())
      if (res >= 0 && res <= parseInt($('#max_ball').val()))
        $.getJSON $(this).parents('tr').find('form').attr('action'),{
          'score': res
        }, (result) ->
          btn.parents('tr').removeClass('warning')
          span = btn.parents('tr').find('.editEntranceAchievement').parent().find('span')
          btn.parents('tr').find('.editEntranceAchievement').parent().find('p').empty()
          span.empty()
          span.text(result.score)
          btn.parents('tr').find('.editEntranceAchievement').hide()
          td = btn.parent()
          td.empty()
          td.html('<button class="btn-default btn editEntranceAchievementButton">Редактировать</button>')
      else
        val = $(this).parents('tr').find('.score')
        val.val(val.attr('value'))
        $(this).parents('tr').addClass('warning')
        btn.parents('tr').find('.editEntranceAchievement').hide()
        btn.parents('tr').find('.editEntranceAchievement').parent().find('span').parent().find('.text-danger').remove()
        btn.parents('tr').find('.editEntranceAchievement').parent().find('span').parent().append($('<p class="text-danger">Вы пытались ввести некорректное значение</p>'))
        td = btn.parent()
        td.empty()
        td.html('<button class="btn-default btn editEntranceAchievementButton">Редактировать</button>')