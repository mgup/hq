$ ->
  $('#modalForName').click (e) ->
    e.preventDefault()
    $('#studentnameModal').modal('hide')
    $('#personNameBtn').text("#{$('#person_fname_attributes_ip').val()} #{$('#person_iname_attributes_ip').val()} #{$('#person_oname_attributes_ip').val()}")