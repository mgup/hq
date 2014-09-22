$ ->
  root = $('#matrixHQ').attr('href')
  all_causes = []
  $('.support_check').click ->
    if this.checked
      $('.support_check').each ->
        this.checked = null
      this.checked = true

#  $('.support_reasons').click ->
#    causes = []
#    $('.support_reasons').each ->
#      if this.checked
#        causes.push $(this).val()
#    all_causes = causes

  $('#supportPreventModal').click (e) ->
    e.preventDefault()
    key = true
    support = false
    causes = []
    $('.support_reasons').each ->
      if $(this).prop('checked') == true
        support = true
        causes.push $(this).val()
    all_causes = causes
    if support
      $('.form-control').each ->
        key*=($(this).val() != '')
        if ($(this).val() == '') then $(this).closest('.row').addClass('has-error') else $(this).closest('.row').removeClass('has-error')
      if key
        $.ajax "#{root}students/#{$('#my_support_support_student').val()}/supports/options?causes=#{all_causes}"
        $('#preventionSupport').modal('show');
      else
        alert('Не все поля заполнены!')
    else
      alert('Вы не выбрали ни одной причины!')
      $('html, body').animate({ scrollTop: 0 }, 'slow');

  $('#formpullstudents').change ->
    $.getJSON root+'ajax/group_students', {
      'faculty': $('#faculty').val(),
      'form' : $('#form option:selected').val(),
      'course' : $('#course option:selected').val(),
      'speciality' : $('#speciality option:selected').val()
    },(data) ->
      element = $('table#studentsForSupport').find('tr')
      element.empty()
      $(data).each ->
        element.append($('<td style="vertical-align: top;"></td>').attr({'id': this.id}))
        group = $('#studentsForSupport #' + this.id)
        group.append('<h3 class="print-students-from-group">' + this.name + '</h3>')
        group.append(
          $('<ul class="list-unstyled nav nav-stacked"></ul>')
        )
        ul = group.find('ul')
        $(this.students).map ->
          ul.append('<li><a href="' + (root + 'students/' + this.id + '/supports/new') + '" style="color: black;"><strong>'+this.index+'</strong>  '+this.fullname+'  <span class="glyphicon glyphicon-list-alt"></span></a></li>')
      element.trigger('liszt:updated')