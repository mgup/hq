$ ->
  root = $('#matrixHQ').attr('href')
#  $('#filterforusers').submit ->
#    name = $('#name').val()
#    department = $('#department option:selected').val()
#    position = $('#position').val()
#    params = 'name='+name+'&department='+department+'&position='+position
#    $.ajax root+'users_filter?' + params
#    return false

#  $('#filterforprices').submit ->
#    speciality = $('#speciality').val()
#    year = $('#year').val()
#    form = $('#form').val()
#    faculty = $('#faculty').val()
#    params = 'year='+year+'&form='+form+'&faculty='+faculty
#
#    if !speciality
#      params += ('&speciality='+speciality)
#
#    $.ajax root+'finance/prices_filter?' + params
#    return false
