$ ->
  root = $('#matrixHQ').attr('href')
  $('.editMarkField').hide()
  $('.editMarkButton').click ->
    btn = $(this)
    btn.parents('tr').find('.editMarkField').show()
    btn.text('Сохранить');
    btn.addClass('btn-success')
    btn.click ->
      mark = $(this).parents('tr').find('.mark_id').val()
      value = $(this).parents('tr').find('label.active').find('input').val()
      params = '&mark='+value
      $.ajax type: "PUT", url: (root+ $('form.marks').attr('action') + '/marks/' + mark + '?' + params)
      return false
    return false