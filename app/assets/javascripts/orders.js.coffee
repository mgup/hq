#  Запросы к серверу пока закомментируем

$ ->
  $('.meta-popover .cancel').on 'click', ->
      $('#meta' + $(this).data('uid') + '.hasDatepicker').datepicker('destroy')
      $('#' + $(this).data('uid')).popover('hide')


# Создание мета-блока с текстом, связанным со студентом.
#
# @param uid

@initOrderMetaTextStudent = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  text = $this.attr('data-meta-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-meta-pattern')
  $this.html(text)

  div = $('<div>', {'class' : 'meta-popover meta-text meta-text-student', 'id'  : uid})

  input = $('<textarea>', {'rows' : 5, 'class' : 'form-control', 'id' : 'meta' + uid, 'width' : required ? '234px' : '300px'})
  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text'      : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<span>', {'class' : 'cancel', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)
    $('#meta' + uid).val($this.attr('data-meta-text'))


#Создание мета-блока с текстом, связанным с приказом.
#@param uid

@initOrderMetaTextOrder = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  text = $this.attr('data-meta-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-meta-pattern')
  $this.html(text)

  div = $('<div>', {'class' : 'meta-popover meta-text meta-text-order', 'data-uid'  : 'uid'})

  input = $('<textarea>', {'rows' : 5, 'id' : 'meta' + uid, 'width' : required ? '234px' : '300px'})
  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  if !required
    div.append(' или ');
    $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid' : uid}).appendTo(div)

  div.append(' или ')

  $('<span>', {'class' : 'cancel', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)

    $('#meta' + uid).val($this.attr('data-meta-text'))


#Создание мета-блока с датой, связанной со студентом.

@initOrderMetaDateStudent = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  text = $this.attr('data-meta-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-meta-pattern')
  $this.html(text)

  div = $('<div>', {'class' : 'meta-popover meta-text meta-text-student', 'id'  : uid})

  input = $('<input>', {'type' : 'text', 'id' : 'meta' + uid, 'class' : 'datepicker', 'width' : required ? '234px' : '300px'})
  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text'      : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<span>', {'class' : 'cancel', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('.meta-text .save').on 'click', ->
      metaSaveButtonClick()

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)


    $('#meta' + uid).val($this.attr('data-meta-text'))
    $('#meta' + uid).datepicker({
      format: 'dd.mm.yyyy',
      language: 'ru-RU'
    })

#  initEventListeners

#Создание мета-блока с датой, связанной с приказом.
#@param uid

@initOrderMetaDateOrder = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  text = $this.attr('data-meta-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-meta-pattern')
  $this.html(text)

  div = $('<div>', {'class' : 'meta-popover meta-text meta-text-order', 'data-uid'  : 'uid'})

  input = $('<input>', {'type' : 'text', 'id' : 'meta' + uid, 'class' : 'datepicker', 'width' : required ? '234px' : '300px'})
  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<span>', {'class' : 'cancel', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)


    $('#meta' + uid).val($this.attr('data-meta-text'))
    $('#meta' + uid).datepicker({ 'dateFormat': 'dd.mm.yy' })
    $('#meta' + uid).datepicker($.datepicker.regional['ru'])


#Создание мета-блока с вариантами текста, связанного с приказом.
#@param uid

@initOrderMetaSelectOrder = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  text = $this.attr('data-meta-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-meta-pattern')
  $this.html(text)

  div = $('<div>', {'class' : 'meta-popover meta-select meta-text-order', 'data-uid'  : uid})

  select = $('<select>', {'id' : 'meta' + uid, 'width' : required ? '234px' : '300px'})
  options = $this.attr('data-meta-options').split('|')
  optionsText = $this.attr('data-meta-options-text').split('|')
  $('<option>', {'value' : optionsText[i], 'html' : options[i]}).appendTo(select) for i in [(options.length - 1)..0]
  div.append(select)

  $('<button>', {'class' : 'btn btn-primary save', 'text' : 'Сохранить', 'data-uid' : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<span>', {'class' : 'cancel', 'text' : 'отменить', 'data-uid' : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
     $(this).popover('show');

  if !required
    $('#' + uid + ' + div').css('max-width', 340)
    $('#' + uid + ' + div').css('width', 340)

  $('#meta' + uid).val($this.attr('data-meta-text'))

  $('div[data-uid="' + uid + '"] .save').on 'click', ->
#      Сохраняем выбранное значение в качестве значения мета-блока.
    selectedOption = $('#meta' + $(this).data('uid')).val()
    $('#' + $(this).data('uid')).attr('data-meta-text', selectedOption)
    $('#' + $(this).data('uid')).html(selectedOption)

#      Отправляем данные в базу.
    saveMeta($(this).data('uid'))

#      Прячем мета-блок.
    $('#' + $(this).data('uid')).popover('hide')


@metaSaveButtonClick = ->
  uid = $(this).data('uid')
  $link = $('#' + uid)

  text = if $('#meta' + uid).is('select') then $('#meta' + uid + ' option:selected').text() else $('#meta' + uid).val()
  alert(text)

  $link.attr('data-meta-text', text)
  $link.html(text)

  $('#meta' + uid + '.hasDatepicker').datepicker('destroy')
  saveMeta(uid)
  $link.popover('hide')

  marker = $('.meta-marker[data-uid="' + uid + '"]')
  if marker
    if marker.hasClass('invalid')
      marker.removeClass('invalid')
      marker.addClass('valid')

$('.meta-text .cancel').on 'click', ->
  uid = $(this).data('uid')
  $link = $('#' + uid)
  $link.popover('hide')

$('.meta-text .remove').on 'click', ->
  uid = $(this).data('uid')
  $link = $('#' + uid)

  $link.attr('data-meta-text', 'null')
  $link.html($link.attr('data-meta-pattern'))

  saveMeta(uid)
  $link.attr('data-meta-id', '')
  $link.attr('data-meta-text', '')
  $link.popover('hide')

  marker = $('.meta-marker[data-uid="' + uid + '"]')
  if marker
    if 'required' == marker.attr('data-required') && marker.hasClass('valid')
      marker.removeClass('valid')
      marker.addClass('invalid')

#Создание мета-блока с текстом, связанным со студентом.
#@param uid

@initOrderMetaEmployeeStudent = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  text = $this.attr('data-meta-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-meta-pattern')
  $this.html(text)

  div = $('<div>', {'class' : 'meta-popover meta-text meta-text-student', 'data-uid'  : 'uid'})

  input = $('<select>', {'id' : 'meta' + uid, 'width' : required ? '234px' : '300px'})

#     Загрузка списка сотрудников подразделения.
  data = { 'department' : $this.attr('data-meta-department') }
  if $this.attr('data-meta-roles')
    data.roles = $this.attr('data-meta-roles').split(',')

#  $.ajax('/utility/ajax/users', {
#      'data'      : data,
#      'dataType'  : 'json',
#      'type'      : 'post',
#      'error'     : (jqXHR, textStatus, errorThrown) ->
##        alert('Ошибка при запросе списка сотрудников. В случае повторения ошибки — обратитесь в отдел информационных систем.')
#      'success'   : (response) ->
#          $(response).each ->
#            mask = $this.attr('data-meta-mask')
#            mask = mask.replace('{' + field + '}', this[field]) for field in this
#            mask = mask.replace(' ,', '')
##              Обрабатывает маску с выбором варианта.
##              Сначала меняем {title/position} на #XXXposition}.
#            mask = mask.replace('{' + field + '/', '#' + this[field]) for field in this
##              Если первая замена не сработала (соответствующее поле
##              было пустое), то меняем #position} на YYY.
#            mask = mask.replace('#' + field + '}', this[field]) for field in this
##               Если первая замена сработала, то убираем лишнее поле из
##               маски — #XXXposition} -> #XXX.
#            mask = mask.replace(field + '}', '') for field in this
#
#            mask = mask.replace('#', '')
#
#            mask = $.trim(mask)
#            if ',' == mask[mask.length - 1]
#              mask = mask.substring(0, mask.length - 1)
#
#            option = $('<option>', {
#              'value'         : this.id,
#              'data-name'     : this.name,
#              'data-title'    : this.title,
#              'data-position' : this.position,
#              'data-text'     : mask
#            }).html(mask)
#            input.append(option)
#  })
#  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text' : 'Сохранить', 'data-uid' : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid' : uid}).appendTo(div)

  div.append(' или ')

  $('<span>', {'class' : 'cancel', 'text' : 'отменить', 'data-uid' : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)

    $('#meta' + uid).val($this.attr('data-meta-text'))


#Создание мета-блока для выбора учебного года.
#@param uid Идентификатор мета-блока.

@initOrderMetaAcademicYear = (uid) ->
  currentYear = parseInt($('#' + uid).attr('data-meta-text'))
  if isNaN(currentYear) || '' == currentYear
    currentYear = 2013

  $('#' + uid).attr('data-meta-text', currentYear)

  div = $('<div>', {'class' : 'meta-popover meta-academic-year', 'data-uid' : uid})
  $('#' + uid).html(currentYear + '/' + (currentYear + 1))


#     Сохраняем значение по-умолчанию в базу.
  metaId = $('#' + uid).attr('data-meta-id')
  if '' == metaId || null == metaId
    saveMeta(uid)

  select = $('<select>', {'class': 'meta' + uid})

  $('<option>', {'value' : year, 'html'  : year + '/' + (year + 1)}).appendTo(select) for year in [(currentYear + 1)..2010]
  div.append(select)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid' : uid}).appendTo(div)

  div.append(' или ')

  $('<span>', {'class' : 'cancel', 'text' : 'отменить', 'data-uid' : uid}).appendTo(div)

  $('#' + uid).popover({'html' : true, 'content' : div})
  $('#' + uid).on 'click', ->
    $(this).popover('show')

#        При открытии окна редактирования инициализируем список текущим
#        сохранённым вариантом. Это нужно в тех случаях, когда пользователь
#        открыл окно редактирования, выбрал какой-то левый вариант,
#        но не нажал «Сохранить». Нужно, чтобы этот левый, несохранённый
#        вариант затирался текущим сохранённым.

    currentValue = parseInt($('#' + uid).attr('data-meta-text'))
    $('.meta-popover[data-uid"=' + uid + '"] option').each ->
      if currentValue == $(this).val()
        $(this).attr('selected', 'selected')
        $('#' + $(this).data('uid')).html(currentValue + '/' + (currentValue + 1))

  $('.meta-academic-year .save').on 'click', ->
#      Сохраняем выбранное значение в качестве значения мета-блока.
    selectedYear = parseInt($('.meta' + $(this).data('uid')).val())
    $('#' + $(this).data('uid')).attr('data-meta-text', selectedYear)
    $('#' + $(this).data('uid')).html(selectedYear + '/' + (selectedYear + 1))

#      Отправляем данные в базу.
    saveMeta($(this).data('uid'))

#      Прячем мета-блок.
    $('#' + $(this).data('uid')).popover('hide')


#Сохранение мета-данных в базу.
#@param uid

@saveMeta = (uid) ->
  meta = $('#' + uid)
  data = {}

#    Определяем, есть ли уже идентификатор текущих мета-данных.
  metaId = meta.attr('data-meta-id')
#      Идентификатора нет, то есть мета-данные сохраняются впервые.
  data.id = if ('' == metaId || null == metaId) then null else metaId

#     Заполняем пакет данными из мета-блока.
  data.order   = meta.attr('data-meta-order')
  data.type    = meta.attr('data-meta-type')
  data.object  = meta.attr('data-meta-object')
  data.pattern = meta.attr('data-meta-pattern')
  data.text    = meta.attr('data-meta-text')

#    Отправляем запрос на сервер.
#  $.ajax('/order/view/meta', {
#    'data'      : data,
#    'dataType'  : 'json',
#    'type'      : 'post',
#    'error'     : (jqXHR, textStatus, errorThrown) ->
##      console.log(jqXHR)
##      console.log(textStatus)
##      console.log(errorThrown)
##      alert('Ошибка. Данные не сохранены. В случае повторения ошибки — обратитесь в отдел информационных систем.')
#    'success'   : (response) ->
#      if response.id
#        $('#' + uid).attr('data-meta-id', response.id)
#  })
