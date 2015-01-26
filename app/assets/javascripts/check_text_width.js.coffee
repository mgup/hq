$ ->
  checkTextWidth = (txt, element, otherwiseText) ->
    auxDiv = $("<div>").addClass('auxdiv').css({
      position: "absolute",
      height: "auto",
      marginLeft : "-1000px",
      marginTop : "-1000px",
      width: "auto"
    })
    $(auxDiv).appendTo($("body")).html(txt)

    width = (auxDiv.width() + 1)

    if element.get(0).tagName == 'INPUT'
      element.val(if width > element.width() then otherwiseText else txt)
    else
      element.html(if width > element.width() then otherwiseText else txt)

    $(".auxdiv").remove()
    auxDiv.remove()