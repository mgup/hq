$ ->
  root = $('#matrixHQ').attr('href')
  $('#formpullgroupstudents').change ->
    $.getJSON root+'ajax/group_students', {
      'faculty': $('#faculty').val(),
      'form' : $('#form option:selected').val(),
      'course' : $('#course option:selected').val(),
      'speciality' : $('#speciality option:selected').val()
    },(data) ->
      element = $('table#studentsByGroups').find('tr')
      element.empty()
      $(data).each ->
        element.append($('<td style="vertical-align: top;"></td>').attr({'id': this.id}))
        group = $('#studentsByGroups #' + this.id)
        group.append('<h3 class="print-students-from-group">' + this.name + '  <span class="glyphicon glyphicon-print"></span></h3>')
        group.append(
          $('<ul class="list-unstyled nav nav-stacked"></ul>')
        )
        ul = group.find('ul')
        $(this.students).map ->
          ul.append('<li><a href="#" style="color: black;"><strong>'+this.index+'</strong>  '+this.fullname+'<br><small class="text-muted">'+this.status+'</small></a></li>')


      element.trigger('liszt:updated')
      $(document).find('.print-students-from-group').click ->
        href = root + 'groups/'+ $(this).closest('td').attr('id') + '/print_group.pdf'
        window.location = href
