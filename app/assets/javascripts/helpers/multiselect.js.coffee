$ ->
  $('.multiselect a').each ->
    checkbox = $(this).find('input[type="checkbox"]')
    if checkbox[0] && checkbox[0].checked
      $(this).addClass('selected')

    $(this).click (e) ->
      e.preventDefault()
      e.stopPropagation()

      checkbox = $(this).find('input[type="checkbox"]')
      if checkbox
        c = checkbox[0]
        if c.checked
          c.checked = false
          $(this).removeClass('selected')
        else
          c.checked = true
          $(this).addClass('selected')