$ ->
  updateSpecialities = (faculty_id) ->
    $.getJSON '/study/disciplines/ajax/specialities', {
      'faculty': faculty_id
    }, (specialities) ->
      select = $('.ajax-speciality')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option("#{speciality.code} #{speciality.name}", speciality.id)
        ) for speciality in specialities
        $(select).val(specialities[0].id).change()

  updateGroups = (speciality_id) ->
    $.getJSON '/study/disciplines/ajax/groups', {
      'speciality': speciality_id
    }, (groups) ->
      select = $('.ajax-group')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option(group.name, group.id)
        ) for group in groups
        $(select).val(groups[0].id).change()

  $('.ajax-faculty').change ->
    updateSpecialities($(this).val())
  $('.ajax-speciality').change ->
    updateGroups($(this).val())

  if $('.ajax-speciality').length > 0 and 0 == $('.ajax-speciality')[0].options.length
    $('.ajax-faculty').change() if 0 == $('.ajax-speciality')[0].options.length