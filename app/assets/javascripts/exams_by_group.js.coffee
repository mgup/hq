$ ->
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
      $(data.disciplines).map ->
        dl.append($("<dt>#{this.name}</dt>")).text()
        dl.append($("<dd id='dd_#{this.id}'></dd>"))
        dd = $('#examsByGroups').find('#dd_'+ this.id)
        dd.append($('<table></table>'))
        $(this.exams).map ->
          dd.children('table').append("<tr><td>#{this.id}</td><td>#{this.name}</td>
                                       <td><input class='form-control' value=#{ if this.date != null then this.date else '' }>
                                       </td><td><button class='saveDate btn btn-default' data-value=#{this.id}>Сохранить дату</button></td>
                                       <td><a href='#' class='btn btn-primary' title='Распечатать ведомость'><span class='glyphicon glyphicon-print'></span></a></td></tr>")

      div.append('<button id="addDis" class="btn btn-default">Добавить предмет для группы</button>')
      div.append('<a id="modalBtn" data-toggle="modal" href="#addDisciplineModal" class="hidden"></a>')
      div.trigger('liszt:updated')

      $('#addDis').click ->
        group = $('#examsByGroups').find('input:hidden').val()
        $.ajax root + 'study/plans/add_discipline?group=' + group
