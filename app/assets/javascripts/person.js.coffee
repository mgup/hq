$ ->
  root = $('#matrixHQ').attr('href')
  $('#modalForName').click (e) ->
    e.preventDefault()
    $('#studentnameModal').modal('hide')
    $('#personNameBtn').text("#{$('#person_fname_attributes_ip').val()} #{$('#person_iname_attributes_ip').val()} #{$('#person_oname_attributes_ip').val()}")

  $('.save_employer').click (e) ->
    e.preventDefault()
    person = $(this).data('value')
    $.ajax "#{root}persons/#{person}/create_employer",
      data: {
        'employer': $("#employer_#{person}").val()
      }

