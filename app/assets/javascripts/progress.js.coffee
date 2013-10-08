$ ->
  $('.view-group-progress').click (event) ->
    event.preventDefault()
    group = $('#progress_group_id').val()
    if '' == group || null == group then alert 'Сначала необходимо выбрать группу.' else document.location = document.location + '/' + group + '/progress'


  if $('#progress_group').val()
    group_now = $('#progress_group').val()
    $.ajax '/study/group/' + group_now + '/progress/change_discipline'



  $('#disciplines_for_group').change ->
    discipline = $(this).children(":selected").val()
    group = $('#progress_group').val()
    params = if discipline != '' then 'discipline=' + discipline else ''
    $.ajax '/study/group/' + group + '/progress/change_discipline?' + params