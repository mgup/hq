$ ->
  $('.save_ciot').click ->
    div = $(this).closest('div')
    student =  div.find('input').val()
    $("#edit_student_#{student}").trigger('submit')
    login = $("#edit_student_#{student}").find('#student_ciot_login')
    password = $("#edit_student_#{student}").find('#student_ciot_password')
    login.attr('value', login.val())
    password.attr('value', password.val())
    $('.modal').modal('hide')
    $('div#ajax_content table>tbody>tr>td:nth-child(1)').each ->
      if $(this).text() == student
        tr = $(this).closest('tr')
        $(tr.children().get(5)).html($("#edit_student_#{student}").find('#student_ciot_login').val())
        $(tr.children().get(6)).html($("#edit_student_#{student}").find('#student_ciot_password').val())

  returnValues = (elem) ->
    div = elem.closest('.modal')
    student =  div.find('.modal-footer').find('input').val()
    login = $("#edit_student_#{student}").find('#student_ciot_login')
    password = $("#edit_student_#{student}").find('#student_ciot_password')
    login.val(login.attr('value'))
    password.val(password.attr('value'))

  $('.close').click ->
    returnValues($(this))

  $('.cancell').click ->
    returnValues($(this))