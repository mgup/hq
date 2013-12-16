$ ->
  $('.support_check').click ->
    if this.checked
      $('.support_check').each ->
        this.checked = null
      this.checked = true
