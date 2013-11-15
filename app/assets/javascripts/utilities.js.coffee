$ ->
  $('.scroll-to-top').each ->
    $(this).click (e) ->
      e.preventDefault()
      $('html, body').animate({
        scrollTop: 0
      }, 200)
