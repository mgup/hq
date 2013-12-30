$ ->
  $("#document_doc_eternal").click ->
    if $(this).hasClass('checked')
      $("#document_doc_expire_date").show()
      $(this).removeClass('checked')
      $("#document_doc_expire_date").attr('required', 'required')
    else
      $("#document_doc_expire_date").hide()
      $(this).addClass('checked')
      $("#document_doc_expire_date").val('')
      $("#document_doc_expire_date").removeAttr('required')