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

  updateSpecialitiesAll = (faculty_id) ->
    $.getJSON root+'study/disciplines/ajax/specialities', {
      'faculty': faculty_id
    }, (specialities) ->
      select = $('.ajax-speciality-all')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option('все специальности', '')
        )
        select.options.add(
          new Option("#{speciality.code} #{speciality.name}", speciality.id)
        ) for speciality in specialities
#        $(select).val(select.options.first).change()

  updateGroups = (groups) ->
      select = $('.ajax-group')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option(group.name, group.id)
        ) for group in groups
        if groups.length > 0
          $(select).val(groups[0].id).change()

  updateGroupsAll = (groups) ->
      select = $('.ajax-group-all')[0]
      if select
        select.options.length = 0
        select.options.add(
          new Option('все группы', '')
        )
        select.options.add(
          new Option(group.name, group.id)
        ) for group in groups

		
  updateStudents = (group_id) ->
    if group_id != null
      $.getJSON root+'my/ajax/students', {
        'group': group_id
      }, (students) ->
        select = $('.ajax-student')[0]
        if select
          select.options.length = 0
          select.options.add(
            new Option("#{student.name}", student.id)
          ) for student in students
    else
      $('.ajax-student')[0].empty()

  $('.ajax-faculty').change ->
    updateSpecialities($(this).val())
    updateSpecialitiesAll($(this).val())


  $('.ajax-group').change ->
    updateStudents($(this).val())

  $('.ajax-speciality').change ->
    $.getJSON root+'study/disciplines/ajax/groups', {
      'speciality':  $(this).val(),
      'form' : $('.ajax-form').val(),
      'course' : $('.ajax-course').val()
    }, (groups) ->
      updateGroups(groups)
	  
  $('.ajax-speciality-all').change ->
    $.getJSON root+'study/disciplines/ajax/groups', {
      'speciality':  $(this).val(),
      'form' : $('.ajax-form').val(),
      'course' : $('.ajax-course').val()
    }, (groups) ->
      updateGroupsAll(groups)
	

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