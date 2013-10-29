$ ->
  $('.multiselect').multiselect({
    selectedList: 4,
    checkAllText: 'Выбрать все',
    uncheckAllText: 'Снять выбор',
    selectedText: '# выбрано'
  }).multiselectfilter({
    label: '',
    placeholder: 'Введите слово'
  })

  $('.multiselect#faculty').multiselect({
    noneSelectedText: 'Выберите институт <span class="caret pull-right" style="margin-top: 9px"></span>'
  })
  $('.multiselect#status').multiselect({
    noneSelectedText: 'Выберите статус <span class="caret pull-right" style="margin-top: 9px"></span>'
  })
  $('.multiselect#form').multiselect({
    noneSelectedText: 'Выберите форму обучения <span class="caret pull-right" style="margin-top: 9px"></span>'
  })
  $('.multiselect#finance').multiselect({
    noneSelectedText: 'Выберите основу обучения <span class="caret pull-right" style="margin-top: 9px"></span>'
  })
  $('.multiselect#speciality').multiselect({
    noneSelectedText: 'Выберите специальность <span class="caret pull-right" style="margin-top: 9px"></span>'
  })
  $('.multiselect#course').multiselect({
    noneSelectedText: 'Выберите курс <span class="caret pull-right" style="margin-top: 9px"></span>'
  })
  $('.multiselect#group').multiselect({
    noneSelectedText: 'Выберите группу <span class="caret pull-right" style="margin-top: 9px"></span>'
  })
