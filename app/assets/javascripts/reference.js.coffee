$ ->
  $(".addOptions").hide()
  $("#addOrders").click ->
    if $(this).hasClass('checked')
      $("#studentOrdersAdd").hide()
      $(this).removeClass('checked')
    else
      $("#studentOrdersAdd").show()
      $(this).addClass('checked')

  $("#addPeriod").click ->
    if $(this).hasClass('checked')
      $("#studentPeriodAdd").hide()
      $(this).removeClass('checked')
    else
      $("#studentPeriodAdd").show()
      $(this).addClass('checked')

  $("#addPlace").click ->
    if $(this).hasClass('checked')
      $("#studentPlaceAdd").hide()
      $(this).removeClass('checked')
    else
      $("#studentPlaceAdd").show()
      $(this).addClass('checked')

  $("#checkAllOrders").click ->
    if $(this).hasClass('checked')
      $(this).removeClass('checked')
      $(".orderCheckbox").each ->
        $(this).prop("checked", false)
    else
      $(this).addClass('checked')
      $(".orderCheckbox").each ->
        $(this).prop("checked", true)
