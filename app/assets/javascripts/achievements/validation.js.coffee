$ ->
  recalcBaseCredit = (id) ->
    $credit = $('input.achievement-credit[data-id="' + id + '"]')
    base = parseFloat($credit.attr('data-base'))
    credit = parseFloat($credit.attr('data-credit'))
    value = parseFloat($('.achievement-value[data-id="' + id + '"]').eq(0).val()) * credit / base
    if isNaN(value)
      $('input[type="submit"][data-id="' + id + '"]').eq(0).attr('disabled', 'disabled')
      $credit.val('НЕ УКАЗАНО ЗНАЧЕНИЕ!')
    else
      $('input[type="submit"][data-id="' + id + '"]').eq(0).removeAttr('disabled')
      $credit.val(value)

  $('.achievement-value').each ->
    recalcBaseCredit($(this).attr('data-id'))

  $(document).on 'keyup', '.achievement-value', ->
    id = $(this).attr('data-id')
    $('input[type="submit"][data-id="' + id + '"]').eq(0).addClass('btn-primary')
    recalcBaseCredit(id)

