$ ->
  updateTeachers = (teachers) ->
    select = $('.ajax-teacher')[0]
    if select
      select.options.length = 0
      select.options.add(
        new Option(teacher.full_name, teacher.id)
      ) for teacher in teachers
      $(select).val(teachers[0].id).change() if teachers[0]

  $('.ajax-subdepartment').change ->
    alert('dhsffffff')
    $.getJSON "#{root}ajax/teachers", {
      'subdepartment':  $(this).val()
    }, (teachers) ->
      updateTeachers(teachers)