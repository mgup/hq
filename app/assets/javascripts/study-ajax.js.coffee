$ ->
  updateSpecialities = (faculty_id) ->
    $.getJSON 'ajax/specialities', {
      'faculty': faculty_id
    }, (data) ->
      select = $('.ajax-speciality')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option("#{option.code} #{option.name}", option.id)
        ) for option in data
        $(select).val(data[0].id).change()

  updateGroups = (speciality_id) ->
    $.getJSON 'ajax/groups', {
      'speciality': speciality_id
    }, (data) ->
      select = $('.ajax-group')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option(option.name, option.id)
        ) for option in data
        $(select).val(data[0].id).change()

  $('.ajax-faculty').change ->
    updateSpecialities($(this).val())
  $('.ajax-speciality').change ->
    updateGroups($(this).val())

  $('.ajax-faculty').change()