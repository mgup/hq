$ ->
  $('.examBall').change ->
    current = + $(this).parent().find('.currentBall').text()
    exam = parseInt($(this).val())

    $(this).parents('div').find('.finalSumBall').val(current+exam).change()
