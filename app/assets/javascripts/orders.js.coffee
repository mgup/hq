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

  $('<a>', {'class' : 'cancel', 'href' :  '#', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('.meta-text .save').on 'click', ->
      metaSaveButtonClick(this)
    $('.meta-text .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)
      $('.meta-text .remove').on 'click', ->
        metaRemoveButtonClick(this)
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

  input = $('<textarea>', {'rows' : 5, 'class': 'form-control', 'id' : 'meta' + uid, 'width' : required ? '234px' : '300px'})
  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  if !required
    div.append(' или ');
    $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid' : uid}).appendTo(div)

  div.append(' или ')

  $('<a>', {'class' : 'cancel', 'href' :  '#', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('.meta-text .save').on 'click', ->
      metaSaveButtonClick(this)
    $('.meta-text .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)
      $('.meta-text .remove').on 'click', ->
        metaRemoveButtonClick(this)
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

  input = $('<input>', {'type' : 'text', 'id' : 'meta' + uid, 'class' : 'form-control datepicker', 'width' : required ? '234px' : '300px'})
  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text'      : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<a>', {'class' : 'cancel', 'href' :  '#', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('.meta-text .save').on 'click', ->
      metaSaveButtonClick(this)
    $('.meta-text .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)
      $('.meta-text .remove').on 'click', ->
        metaRemoveButtonClick(this)

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

  input = $('<input>', {'type' : 'text', 'id' : 'meta' + uid, 'class' : 'datepicker form-control', 'width' : required ? '234px' : '300px'})
  div.append(input)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<a>', {'class' : 'cancel', 'href' :  '#', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('.meta-text .save').on 'click', ->
      metaSaveButtonClick(this)
    $('.meta-text .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)
      $('.meta-text .remove').on 'click', ->
        metaRemoveButtonClick(this)

    $('#meta' + uid).val($this.attr('data-meta-text'))
    $('#meta' + uid).datepicker({
      format: 'dd.mm.yyyy',
      language: 'ru-RU'
    })


#Создание мета-блока с вариантами текста, связанного с приказом.
#@param uid

@initOrderMetaSelectOrder = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  options = $this.attr('data-meta-options').split('|')
  optionsText = $this.attr('data-meta-options-text').split('|')

  text = $this.attr('data-meta-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-meta-pattern')
  else
    text = options[optionsText.indexOf(text)]
  $this.html(text)

  div = $('<div>', {'class' : 'meta-popover meta-select meta-text-order', 'data-uid'  : uid})

  select = $('<select>', {'id' : 'meta' + uid, 'class': 'form-control', 'width' : required ? '234px' : '300px'})
  $('<option>', {'value' : optionsText[i], 'html' : options[i]}).appendTo(select) for i in [(options.length - 1)..0]
  div.append(select)

  $('<button>', {'class' : 'btn btn-primary save', 'text' : 'Сохранить', 'data-uid' : uid}).appendTo(div)

  if !required
    div.append(' или ')
    $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<a>', {'class' : 'cancel', 'href' :  '#', 'text' : 'отменить', 'data-uid' : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('#meta'+$this.attr('id')+' option[value="'+$this.attr('data-meta-text')+'"]').prop('selected', true)
    $('.meta-select .save').on 'click', ->
      selectedOption = $('#meta' + $(this).data('uid')).val()
      $('#' + $(this).data('uid')).attr('data-meta-text', selectedOption)
      $('#' + $(this).data('uid')).html($('#meta'+$(this).data('uid')+' option[value="'+selectedOption+'"]').text())

      #      Отправляем данные в базу.
      saveMeta($(this).data('uid'))

      #      Прячем мета-блок.
      $('#' + $(this).data('uid')).popover('hide')

    $('.meta-select .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false

  if !required
    $('#' + uid + ' + div').css('max-width', 340)
    $('#' + uid + ' + div').css('width', 340)
    $('.meta-text .remove').on 'click', ->
      metaRemoveButtonClick(this)
  $('#meta' + uid).val($this.attr('data-meta-text'))


@metaSaveButtonClick = (object) ->
  uid = $(object).data('uid')
  $link = $('#' + uid)

  text = if $('#meta' + uid).is('select') then $('#meta' + uid + ' option:selected').text() else $('#meta' + uid).val()

  $link.attr('data-meta-text', text)
  $link.html(text)

  $('#meta' + uid + '.datepicker').datepicker('destroy')
  saveMeta(uid)
  $link.popover('hide')

  marker = $('.meta-marker[data-uid="' + uid + '"]')
  if marker
    if marker.hasClass('invalid')
      marker.removeClass('invalid')
      marker.addClass('valid')

@metaCancelLinkClick = (object) ->
  uid = $(object).data('uid')
  $link = $('#' + uid)
  $link.popover('hide')

@metaRemoveButtonClick = (object) ->
  uid = $(object).data('uid')
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

  input = $('<select>', {'id' : 'meta' + uid, 'class': 'form-control', 'width' : required ? '234px' : '300px'})

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

  $('<a>', {'class' : 'cancel', 'href' :  '#', 'text' : 'отменить', 'data-uid' : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('.meta-text .save').on 'click', ->
      metaSaveButtonClick(this)
    $('.meta-text .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false

    if !required
      $('#' + uid + ' + div').css('max-width', 340)
      $('#' + uid + ' + div').css('width', 340)
      $('.meta-text .remove').on 'click', ->
        metaRemoveButtonClick(this)
    $('#meta' + uid).val($this.attr('data-meta-text'))


#Создание мета-блока для выбора учебного года.
#@param uid Идентификатор мета-блока.

@initOrderMetaAcademicYear = (uid) ->
  currentYear = parseInt($('#' + uid).attr('data-meta-text'))
  if isNaN(currentYear) || '' == currentYear
    currentYear = 2014

  $('#' + uid).attr('data-meta-text', currentYear)

  div = $('<div>', {'class' : 'meta-popover meta-academic-year', 'data-uid' : uid})
  $('#' + uid).html(currentYear + '/' + (currentYear + 1))


#     Сохраняем значение по-умолчанию в базу.
  metaId = $('#' + uid).attr('data-meta-id')
  if '' == metaId || null == metaId
    saveMeta(uid)

  select = $('<select>', {'class': 'form-control meta' + uid})

  $('<option>', {'value' : year, 'html'  : year + '/' + (year + 1)}).appendTo(select) for year in [(currentYear + 1)..2010]
  div.append(select)

  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid' : uid}).appendTo(div)

  div.append(' или ')

  $('<a>', {'class' : 'cancel', 'href' :  '#', 'text' : 'отменить', 'data-uid' : uid}).appendTo(div)

  $('#' + uid).popover({'html' : true, 'content' : div})
  $('#' + uid).on 'click', ->
    $(this).popover('show')

#        При открытии окна редактирования инициализируем список текущим
#        сохранённым вариантом. Это нужно в тех случаях, когда пользователь
#        открыл окно редактирования, выбрал какой-то левый вариант,
#        но не нажал «Сохранить». Нужно, чтобы этот левый, несохранённый
#        вариант затирался текущим сохранённым.

    currentValue = parseInt($('#' + uid).attr('data-meta-text'))
    $('.meta-popover[data-uid="' + uid + '"] option').each ->
      if currentValue == parseInt($(this).val())
        $(this).prop('selected', true)
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

    $('.meta-academic-year .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false


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
  $.getJSON $('#matrixHQ').attr('href')+'ajax/ordermeta', {
    'id':  if ('' == metaId || null == metaId) then null else metaId,
    'order' : meta.attr('data-meta-order'),
    'type' : meta.attr('data-meta-type'),
    'object' : meta.attr('data-meta-object'),
    'pattern' : meta.attr('data-meta-pattern'),
    'text' : meta.attr('data-meta-text')
  }, (meta) ->
    $('#' + uid).attr('data-meta-id', meta.id)
  .success ->
    alert('Информация была успешно сохранена')
    checkForSign()
  .error ->
    alert('Ошибка. Данные не сохранены. В случае повторения ошибки — обратитесь в отдел информационных систем.')
    checkForSign()



@checkForSign = ->
  key = true
  $('.order-meta[data-required="true"]').each ->
    key = key && ($(this).attr('data-meta-text') != '')
  if key
    $('#pushToSign').prop('disabled', false)

$ ->
  checkForSign()