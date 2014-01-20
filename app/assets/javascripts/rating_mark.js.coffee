$ ->
  root = $('#matrixHQ').attr('href')
  $('.examBall').keyup ->
    exam = parseInt($(this).val())
    if (exam < 0 || exam > 100)
      $(this).addClass('danger')
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
        div.append("<span class='label label-#{data.final.span}'>#{data.final.mark}</span>")
        div.trigger('liszt:updated')
        $("#finalSumBall#{data.student}").val(data.final.ball)
        $("##{data.student}_final_mark").val(data.final.value)
      $("#loader#{$(this).data('student')}").hide()
  $('.examBall').trigger('keyup')

  $(".results").change ->
    if $("input[name=#{$(this).attr('name')}]:checked").val() == '0'
     $('.examBall').change()
    else
      div = $("#finalMark#{$(this).data('student')}")
      div.empty()
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
        div.trigger('liszt:updated')
        $("#finalSumBall#{data.student}").val(data.final.ball)
        $("##{data.student}_final_mark").val(data.final.value)
      $("#loader#{$(this).data('student')}").hide()
  $('.examBall').val(0)
  $('.results').change()