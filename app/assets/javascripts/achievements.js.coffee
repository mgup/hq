$ ->
  $('#activities_accordeon').on 'shown.bs.collapse', (e) ->
#    debugger
    $('html, body').animate({
      scrollTop: $(e.target).parent().offset().top - 55
    }, 200)