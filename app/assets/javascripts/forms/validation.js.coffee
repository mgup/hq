$ ->
  $('input.form-control').on 'invalid', (event) ->
    debugger
    $(event.target).addClassName('has-error')