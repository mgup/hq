$ ->
  $('.examBall').change ->
    current = + $(this).parent().find('.currentBall').text()
    exam = parseInt($(this).val())
    $(this).parent().parent().find('.finalSumBall').val(current+exam).change()
