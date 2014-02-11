$ ->
  recalcBaseCredit = (id) ->
    $credit = $('input.achievement-credit[data-id="' + id + '"]')
    base = parseFloat($credit.attr('data-base'))
    credit = parseFloat($credit.attr('data-credit'))
    value = parseFloat($('.achievement-value[data-id="' + id + '"]').eq(0).val()) * credit / base
    if isNaN(value)
      $('input.achievement-save[data-id="' + id + '"]').eq(0).attr('disabled', 'disabled')
      $credit.val('НЕ УКАЗАНО')
    else
      $('input.achievement-save[data-id="' + id + '"]').eq(0).removeAttr('disabled')
      $credit.val(value)

  $('.achievement-value').each ->
    recalcBaseCredit($(this).attr('data-id'))

  $(document).on 'keyup', '.achievement-value', ->
    id = $(this).attr('data-id')
    $('input.achievement-save[data-id="' + id + '"]').eq(0).addClass('btn-primary')
    recalcBaseCredit(id)

  checkCost = (id) ->
    $cost = $('input.achievement-cost[data-id="' + id + '"]')
    value = parseFloat($cost.val())
    if isNaN(value)
      $('button.achievement-approve[data-id="' + id + '"]').eq(0).attr('disabled', 'disabled')
      $('.final-approve[data-id="' + id + '"]').eq(0).attr('disabled', 'disabled')
      $cost.addClass('danger')
    else
      $('button.achievement-approve[data-id="' + id + '"]').eq(0).removeAttr('disabled')
      $('.final-approve[data-id="' + id + '"]').eq(0).removeAttr('disabled')
      $cost.removeClass('danger')

  checkMaxMin = (id) ->
    $cost = $('input.achievement-cost[data-id="' + id + '"]')
    value = parseFloat($cost.val())
    max = parseFloat($cost.attr('max'))
    min = parseFloat($cost.attr('min'))
    if (value < min || value > max)
      $('button.achievement-approve[data-id="' + id + '"]').eq(0).attr('disabled', 'disabled')
      $('.final-approve[data-id="' + id + '"]').eq(0).attr('disabled', 'disabled')
      $cost.addClass('danger')
    else
      $('button.achievement-approve[data-id="' + id + '"]').eq(0).removeAttr('disabled')
      $('.final-approve[data-id="' + id + '"]').eq(0).removeAttr('disabled')
      $cost.removeClass('danger')

  $('.achievement-cost').change ->
    checkCost($(this).attr('data-id'))
    $(this).val(parseFloat($(this).val()).toFixed(1))
    if $(this).parents('.selection-validation').length
      checkMaxMin($(this).attr('data-id'))


  $(document).on 'keyup', '.achievement-cost', ->
    id = $(this).attr('data-id')
    $('button.achievement-approve[data-id="' + id + '"]').eq(0).addClass('btn-success')
    checkCost(id)
    if $(this).parents('.selection-validation').length
      checkMaxMin(id)

  $(document).on 'click', '.achievement-approve', ->
    id = $(this).attr('data-id')
    $('.achievement-status[data-id="' + id + '"]').val(2)
    $('form.form-achievement-cost[data-id="' + id + '"]').submit()

  $(document).on 'click', '.achievement-refuse', ->
    id = $(this).attr('data-id')
    $('.achievement-status[data-id="' + id + '"]').val(3)
    $('form.form-achievement-cost[data-id="' + id + '"]').submit()

