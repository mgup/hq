$ ->

  $('.discipline_exams_variants[data-type="1"]').each ->
    if $(this).prop('checked')
      $(this).closest('form').find('.discipline_exams_variants[data-type="1"]').prop('disabled', true)
      $(this).prop('disabled', false)
      $(this).closest('form').find('.fields .exam-type[value="' +  $(this).val() + '"]').parents('.fields').appendTo($(this).parent().next('.for-exam'))
      if $(this).data('type') == 1
        $(this).parent().next('.for-exam').find('.exam-weight').show()

  $('.discipline_exams_variants[data-type="1"]').click ->
    if $(this).prop('checked')
      $(this).closest('form').find('.discipline_exams_variants[data-type="1"]').prop('disabled', true)
      $(this).prop('disabled', false)
    else
      $(this).closest('form').find('.discipline_exams_variants[data-type="1"]').prop('disabled', false)

  $('.discipline_exams_variants').click ->
    $this = $(this)
    if $this.prop('checked')
      $link = $(this).closest('form').find('a[data-blueprint-id="exams_fields_blueprint"]')
      $link.attr('data-value', $this.val()).attr('data-type', $this.data('type'))
      $link.click()
      $(this).closest('form').find('.fields .exam-type[value="' +  $this.val() + '"]').closest('.fields').appendTo($this.parent().next('.for-exam'))
    else
      $field = $(this).closest('form').find('.fields .exam-type[value="' + $this.val() + '"]')
      $field.parents('.discipline_exams_fields').children('.remove_nested_fields').click()

  $(document).on 'nested:fieldAdded:exams', (event) ->
    exam_field = event.field.find('.exam-type')
    type = $(event.link).attr('data-type')
    exam_field.val($(event.link).attr('data-value'))
    if type == '1'
      exam_field.parents('.discipline_exams_fields').find('.exam-weight').show()

#  Array::present = ->
#    @.length > 0
#
#  root = $('#matrixHQ').attr('href')
#  $('#groupforexams').change ->
#    $.getJSON root+'ajax/group_exams', {
#      'group': $(this).val()
#    },(data) ->
#      div = $('div#examsByGroups')
#      div.empty()
#      div.append("<input type='hidden' value=#{data.id}>")
#      div.append('<h3>'+data.name+'</h3>')
#      div.append('<dl></dl>')
#      dl = $('#examsByGroups').find('dl')
#      unless data.disciplines.present()
#        dl.append($('<p class="lead">Для этой группы учебный план ещё не составлен</p>'))
#      else
#        $(data.disciplines).map ->
#          discipline = this
#          dl.append($("<br><dt>#{discipline.name} <button title='Редактировать дисциплину' class='editDiscipline btn btn-default btn-xs' data-value=#{this.id}><span class='glyphicon glyphicon-edit'></span></button></dt><br>")).text()
#          dl.append($("<dd id='dd_#{this.id}'></dd>"))
#          dd = $('#examsByGroups').find('#dd_'+ discipline.id)
#          dd.append($('<table></table>'))
#          $(discipline.exams).map ->
#            dd.children('table').append("<tr><td>#{this.id}</td><td>#{this.name}</td>
#                                         <td><input class='datepicker form-control' value=#{ if this.date != null then this.date else '' }></td>
#                                         <td><button class='saveDate btn btn-default' data-input=#{discipline.id} data-value=#{this.id}>Сохранить дату</button></td>
#                                         <td><a href='/study/disciplines/#{discipline.id}/exams/#{this.id}/print.pdf' class='btn btn-info' title='Распечатать ведомость'><span class='glyphicon glyphicon-print'></span></a></td>
#                                         <td><button data-value=#{this.id} class='repeatAdd btn btn-default' title='Перезачёты/пересдачи'><span class='glyphicon glyphicon-retweet'></span></button></td>
#                                         <td><a href='/study/disciplines/#{discipline.id}/exams/#{this.id}' data-value='delete' class='delete btn btn-danger' title='Удалить предмет из учебного плана'><span class='glyphicon glyphicon-remove'></span></a></td></tr>")
#
#      div.append('<button id="addDis" class="btn btn-default">Добавить предмет для группы</button>')
#      div.append('<a id="modalBtn" data-toggle="modal" href="#addDisciplineModal" class="hidden"></a>')
#      div.append('<a id="modalEditBtn" data-toggle="modal" href="#editDisciplineModal" class="hidden"></a>')
#      div.append('<a id="modalRepeatBtn" data-toggle="modal" href="#repeatModal" class="hidden"></a>')
#      div.trigger('liszt:updated')
#
#      group = $('#examsByGroups').find('input:hidden').val()
#      $('#addDis').click ->
#        $.ajax root + 'study/plans/add_discipline?group=' + group
#
#      $('.editDiscipline').click ->
#        $.ajax "#{root}study/plans/edit_discipline?group=#{group}&discipline=#{$(this).data('value')}"
#
#      $('.repeatAdd').click ->
#        $.ajax "#{root}study/plans/repeat?group=#{group}&exam=#{$(this).data('value')}"
#
#        # удаление экзамена
#
##      $('.delete').click ->
##        if(confirm('Вы уверены?'))
##          f = document.createElement('form')
##          $(this).after($(f).attr({
##            method: $(this).data('value')
##            action: $(this).attr('href')
##          }).append('<input type="hidden" name="_method" value="'
##                    + $(this).attr('href').toUpperCase()
##                     + '" />'))
##          $(f).submit()
##        return false
#
#      $('.saveDate').click ->
#        $.ajax "#{root}study/plans/#{$(this).data('value')}/updatedate?date=#{$(this).parents('tr').find('.datepicker').val()}"