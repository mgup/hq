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