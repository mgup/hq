#$ ->
#  $('.datepicker').datepicker
#    language: 'ru',
#    format: 'dd.mm.yyyy'
#
#
#  $('.chzn-select').chosen()

$ ->
  $('.ace-editor').each ->
    $this = $(this)
    editor = ace.edit($this.attr('id'))
    editor.setTheme('ace/theme/textmate')
    editor.getSession().setMode('ace/mode/xml')
    editor.getSession().on 'change', ->
      $('#' + $this.attr('data-field')).val(editor.getValue())