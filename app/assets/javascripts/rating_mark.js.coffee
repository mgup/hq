$ ->
  root = $('#matrixHQ').attr('href')

  $('.examBall').keyup ->
    exam = parseInt($(this).val())
    if (exam < 0 || exam > 100)
      $(this).addClass('danger')
      $(this).val($(this).attr('value'))
    else
      $(this).removeClass('danger')
      div = $("#finalMark#{$(this).data('student')}")
      div.empty()
      $("#loader#{$(this).data('student')}").show()
      $.getJSON root+'ajax/count_final', {
        'ball': exam,
        'student': $(this).data('student'),
        'discipline': $(this).data('value')
      },
      (data) ->
        div.empty()
        div.append("<span class='label label-#{data.final.span}'>#{data.final.mark}</span>")
        $("#finalSumBall#{data.student}").val(data.final.ball)
        $("##{data.student}_final_mark").val(data.final.value)
      $("#loader#{$(this).data('student')}").hide()

  $(".results").change ->
    if $("input[name=#{$(this).attr('name')}]:checked").val() == '0'
     $(this).parent().find('.examBall').trigger('keyup')
    else
      div = $("#finalMark#{$(this).data('student')}")
      div.empty()
      $(".examBall[data-student=#{$(this).data('student')}]").val(0)
      $("#loader#{$(this).data('student')}").show()
      $.getJSON root+'ajax/count_final', {
        'ball': 0,
        'reason': $("input[name=#{$(this).attr('name')}]:checked").val(),
        'student': $("input[name=#{$(this).attr('name')}]:checked").data('student'),
        'discipline': $("input[name=#{$(this).attr('name')}]:checked").data('value')
      },(data) ->
        div = $("#finalMark#{data.student}")
        div.empty()
        div.append("<span class='label label-#{data.final.span}'>#{data.final.mark}</span>")
        $("#finalSumBall#{data.student}").val(data.final.ball)
        $("##{data.student}_final_mark").val(data.final.value)
        div.trigger('liszt:updated')
      $("#loader#{$(this).data('student')}").hide()

  $('body').on 'click', '.editFinalMarkButton', (e) ->
    e.preventDefault()
    btn = $(this)
    btn.parents('tr').find('.editFinalMarkField').show()
    btn.text('Сохранить');
    btn.addClass('btn-success')

    btn.click ->
      rating_mark = $(this).parents('tr').find('.rating_mark_id').val()
      rating_value = $(this).parents('tr').find('.examBall').val()
      student = $(this).parents('tr').find('.examBall').data('student')
      final_mark = $(this).parents('tr').find('.final_mark_id').val()
      final_value = $("##{student}_final_mark").val()
      $.getJSON ("/study/exammarks/#{rating_mark}/ajax_update"),{
        'final_mark': final_mark,
        'final_value': final_value,
        'rating_value': rating_value
      }, (mark) ->
        span = $("#exam_mark_li_#{student}")
        span.empty()
        span.text(mark.result)
        btn.parents('tr').find('.editFinalMarkField').hide()
        td = btn.parent()
        td.empty()
        td.html('<button class="btn-default btn editFinalMarkButton">Редактировать</button>')

  if $('#new_results').val() == '1'
    $('.examBall').val(0)
  $('.results').change()
