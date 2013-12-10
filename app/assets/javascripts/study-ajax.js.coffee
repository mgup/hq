$ ->
  root = $('#matrixHQ').attr('href')
  updateSpecialities = (faculty_id) ->
    $.getJSON root+'study/disciplines/ajax/specialities', {
      'faculty': faculty_id
    }, (specialities) ->
      select = $('.ajax-speciality')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option("#{speciality.code} #{speciality.name}", speciality.id)
        ) for speciality in specialities
        $(select).val(specialities[0].id).change()

  updateGroups = (groups) ->
      select = $('.ajax-group')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option(group.name, group.id)
        ) for group in groups
        $(select).val(groups[0].id).change() if groups[0]

  $('.ajax-faculty').change ->
    updateSpecialities($(this).val())
  $('.ajax-speciality').change ->
    $.getJSON root+'study/disciplines/ajax/groups', {
      'speciality':  $(this).val(),
      'form' : $('.ajax-form').val(),
      'course' : $('.ajax-course').val()
    }, (groups) ->
      updateGroups(groups)

  $('.ajax-form').change ->
    $.getJSON root+'study/disciplines/ajax/groups', {
      'speciality':  $('.ajax-speciality').val(),
      'form' : $(this).val(),
      'course' : $('.ajax-course').val()
    }, (groups) ->
      updateGroups(groups)

  $('.ajax-course').change ->
    $.getJSON root+'study/disciplines/ajax/groups', {
      'speciality':  $('.ajax-speciality').val(),
      'form' : $('.ajax-form').val(),
      'course' : $(this).val()
    }, (groups) ->
      updateGroups(groups)

  if $('.ajax-speciality').length > 0 and 0 == $('.ajax-speciality')[0].options.length
    $('.ajax-faculty').change() if 0 == $('.ajax-speciality')[0].options.length
    $('.ajax-speciality').change() if 0 == $('.ajax-group')[0].options.length