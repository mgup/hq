@initEditAchievementForm = (form) ->
  $form = $(form)

  $form.submit ->
    $form.find('.achievement-cost').removeAttr('disabled')

  has_value = $form.find('.achievement-value').eq(0)
  if has_value.length > 0
    activity_base = parseFloat($form.find('.activity-base').val())
    activity_credit = parseFloat($form.find('.activity-credit').val())
    $(has_value).keyup ->
      $form.find('.achievement-maximum-cost').val(parseFloat($(this).val()) * activity_credit / activity_base)
      $form.find('.achievement-cost').val(parseFloat($(this).val()) * activity_credit / activity_base)
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
