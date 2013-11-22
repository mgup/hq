$ ->
  Array::present = ->
    @.length > 0

  root = $('#matrixHQ').attr('href')
  $('#groupforexams').change ->
    $.getJSON root+'ajax/group_exams', {
      'group': $(this).val()
    },(data) ->
      div = $('div#examsByGroups')
      div.empty()
      div.append("<input type='hidden' value=#{data.id}>")
      div.append('<h3>'+data.name+'</h3>')
      div.append('<dl></dl>')
      dl = $('#examsByGroups').find('dl')
      unless data.disciplines.present()
        dl.append($('<p class="lead">Для этой группы учебный план ещё не составлен</p>'))
      else
        $(data.disciplines).map ->
          discipline = this
          dl.append($("<br><dt>#{discipline.name} <button title='Редактировать дисциплину' class='editDiscipline btn btn-default btn-xs' data-value=#{this.id}><span class='glyphicon glyphicon-edit'></span></button></dt><br>")).text()
          dl.append($("<dd id='dd_#{this.id}'></dd>"))
          dd = $('#examsByGroups').find('#dd_'+ discipline.id)
          dd.append($('<table></table>'))
          $(discipline.exams).map ->
            dd.children('table').append("<tr><td>#{this.id}</td><td>#{this.name}</td>
                                         <td><input class='datepicker form-control' value=#{ if this.date != null then this.date else '' }></td>
                                         <td><button class='saveDate btn btn-default' data-input=#{discipline.id} data-value=#{this.id}>Сохранить дату</button></td>
                                         <td><a href='/study/disciplines/#{discipline.id}/exams/#{this.id}/print.pdf' class='btn btn-info' title='Распечатать ведомость'><span class='glyphicon glyphicon-print'></span></a></td>
                                         <td><button data-value=#{this.id} class='repeatAdd btn btn-default' title='Перезачёты/пересдачи'><span class='glyphicon glyphicon-retweet'></span></button></td>
                                         <td><a href='#' class='btn btn-danger' title='Удалить предмет из учебного плана'><span class='glyphicon glyphicon-remove'></span></a></td></tr>")

      div.append('<button id="addDis" class="btn btn-default">Добавить предмет для группы</button>')
      div.append('<a id="modalBtn" data-toggle="modal" href="#addDisciplineModal" class="hidden"></a>')
      div.append('<a id="modalEditBtn" data-toggle="modal" href="#editDisciplineModal" class="hidden"></a>')
      div.append('<a id="modalRepeatBtn" data-toggle="modal" href="#repeatModal" class="hidden"></a>')
      div.trigger('liszt:updated')

      group = $('#examsByGroups').find('input:hidden').val()
      $('#addDis').click ->
        $.ajax root + 'study/plans/add_discipline?group=' + group

      $('.editDiscipline').click ->
        $.ajax "#{root}study/plans/edit_discipline?group=#{group}&discipline=#{$(this).data('value')}"

      $('.repeatAdd').click ->
        $.ajax "#{root}study/plans/repeat?group=#{group}&exam=#{$(this).data('value')}"

      $('.saveDate').click ->
        $.ajax "#{root}study/plans/#{$(this).data('value')}/updatedate?date=#{$(this).parents('tr').find('.datepicker').val()}"