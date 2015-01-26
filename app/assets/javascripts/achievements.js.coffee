@initEditAchievementForm = (form) ->
  $form = $(form)

  $form.submit (e) ->
    $cost = $form.find('.achievement-cost')
    if $cost.length > 0
      if !(parseFloat($cost.val().match(/^-?\d*(\.\d+)?$/)) > 0)
        e.preventDefault()
        e.stopPropagation()
        alert('Ошибка! Необходимо ввести число. Для ввода десятичного числа используйте точку в качестве разделителя — "10.1", а не "10,1".')
      else
        if parseFloat($cost.val()) > parseFloat($form.find('.achievement-maximum-cost').val())
          e.preventDefault()
          e.stopPropagation()
          alert('Ошибка! Заработанный балл не может быть максимального балла.')
        else
          $form.find('.achievement-cost').removeAttr('disabled')
    else
      $form.find('.achievement-cost').removeAttr('disabled')

  has_value = $form.find('.achievement-value').eq(0)
  if has_value.length > 0
    activity_base = parseFloat($form.find('.activity-base').val())
    activity_credit = parseFloat($form.find('.activity-credit').val())
    $(has_value).keyup ->
      if parseFloat($(this).val().match(/^-?\d*(\.\d+)?$/)) > 0
        max = parseFloat($(this).val()) * activity_credit / activity_base
      else
        max = NaN

      $form.find('.achievement-maximum-cost').val(max)
      $form.find('.achievement-cost').val(max)
    $(has_value).trigger('keyup')
  else
    $form.find('.achievement-maximum-cost').val($form.find('.activity-credit').val())
    if $form.find('.has-partners').eq(0).length > 0
      $form.find('.achievement-cost').val($form.find('.achievement-maximum-cost').val())

  has_partners = $form.find('.has-partners').eq(0)
  if has_partners.length > 0
    $has_partners = $(has_partners)
    $has_partners.change ->
      $cost = $form.find('.achievement-cost')
      if this.checked
        $cost.removeAttr('disabled')
        $cost.val('')
        $cost.focus()
      else
        $cost.attr('disabled', 'disabled')
        $cost.val($form.find('.achievement-maximum-cost').val())

  $('.hide-activity').click (e) ->
    e.preventDefault()

    $(this).parents('form').eq(0).hide()


$ ->
  $('#activities_accordeon .add-activity').click (e) ->
    e.preventDefault()

    id = $(this).attr('data-activity')
    $("\#a#{id}_new_achievement").show()


  $('#activities_accordeon .hide-activity').click (e) ->
    e.preventDefault()

    id = $(this).attr('data-activity')
    $("\#a#{id}_new_achievement").hide()


  $('#activities_accordeon').on 'shown.bs.collapse', (e) ->
    $('html, body').animate({
      scrollTop: $(e.target).parent().offset().top - 55
    }, 200)

  $('.edit-achievement-form').each ->
    initEditAchievementForm(this)
