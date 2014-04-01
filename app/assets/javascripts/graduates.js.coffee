# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  graduateFunction = ->
    $('.graduate_subject_choosingly').each ->
      if $(this).prop('checked')
        $(this).parent().parent().find('.subject-kind').attr('readonly', true)
        $(this).parent().parent().find('.graduate-subject-name').attr('readonly', true).addClass('choice-discipline')
        $(this).parent().parent().parent().find('.add_choice_subject').show()
      else
        $(this).parent().parent().parent().find('.subject_choices_fields').hide()
        $(this).parent().parent().parent().find('.add_choice_subject').hide()
    $('.graduate_subject_choosingly').click ->
      kind = $(this).parent().parent().find('.subject-kind').val()
      $(this).parent().parent().parent().find('.add_choice_subject').toggle()
      if kind == '1'
        $(this).parent().parent().parent().find('.subject_choices_fields').toggle()
        val = $(this).parent().parent().find('.graduate-subject-name')
        if val.hasClass('choice-discipline')
          val.val(val.attr('value')).attr('readonly', false).removeClass('choice-discipline')
          $(this).parent().parent().find('.subject-kind').attr('readonly', false)
        else
          val.val('Дисциплина по выбору').attr('readonly', true).addClass('choice-discipline')
          $(this).parent().parent().find('.subject-kind').attr('readonly', true)
      else
        $(this).prop('checked', false)

  graduateFunction()

  $('.edit-graduate').on 'nested:fieldAdded', ->
    graduateFunction()
