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

@initOrderMetaCheckStudent = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  text = $this.attr('data-meta-text')
  isTrue = ('1' == text)
  text = if isTrue then ", #{$this.attr('data-meta-pattern')}" else ", #{$this.attr('data-meta-pattern')}?"
  $this.html(text)
  if isTrue then $this.css('color' : 'green') else $this.css('color' : 'red')

  div = $('<div>', {'class' : 'meta-popover meta-text meta-text-student', 'id'  : uid})
  container = $('<div>', {'class' : 'checkbox'})
  label = $('<label>', {'text' : $this.attr('data-meta-pattern')})
  input = $('<input>', {'type' : 'checkbox', 'id' : 'meta' + uid})
  if isTrue
    input.prop('checked', true)
  else
    input.prop('checked', false)  
  label.prepend(input)
  container.append(label)
  div.append(container)
  div.append($('<br>'))
  $('<button>', {'class' : 'btn btn-primary save', 'text'  : 'Сохранить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')
  $('<button>', {'class' : 'btn btn-danger remove', 'text' : 'Удалить', 'data-uid'  : uid}).appendTo(div)

  div.append(' или ')

  $('<a>', {'class' : 'cancel', 'href' : '#', 'text' : 'отменить', 'data-uid'  : uid}).appendTo(div)

  $this.popover({'html' : true, 'content' : div})

  $this.on 'click', ->
    $(this).popover('show')
    $('.meta-text .save').on 'click', ->
      metaSaveButtonClick(this)
    $('.meta-text .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false

    $('.meta-text .remove').on 'click', ->
      metaRemoveButtonClick(this)
    text = $this.attr('data-meta-text')
    isTrue = ('1' == text)
    text = if isTrue then $this.attr('data-meta-pattern') else "#{$this.attr('data-meta-pattern')}?"
    $('#meta' + uid).val(text)

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
      $('.meta-select .save').off('click')

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
  if $('#meta' + uid).is(':checkbox')
    text = if $('#meta' + uid).is(':checked') then '1' else '0'
    $link.attr('data-meta-text', text)
    pat = if $('#meta' + uid).is(':checked') then ", #{$link.attr('data-meta-pattern')}" else ", #{$link.attr('data-meta-pattern')}?"
    $link.html(pat)
    if $('#meta' + uid).is(':checked') then $link.css('color' : 'green') else $link.css('color' : 'red')
  else
    text = if $('#meta' + uid).is('select') then $('#meta' + uid + ' option:selected').text() else $('#meta' + uid).val()
    $link.attr('data-meta-text', text)
    $link.html(if text == '' then $link.attr('data-meta-pattern') else text)

  $('#meta' + uid + '.datepicker').datepicker('destroy')
  saveMeta(uid)
  $link.popover('hide')
  $('.meta-popover .save').off('click')
  $('.meta-popover .cancel').off('click')
  $('.meta-popover .remove').off('click')

  marker = $('.meta-marker[data-uid="' + uid + '"]')
  if marker
    if marker.hasClass('invalid')
      marker.removeClass('invalid')
      marker.addClass('valid')

@metaCancelLinkClick = (object) ->
  uid = $(object).data('uid')
  $link = $('#' + uid)
  $link.popover('hide')
  $('.meta-popover .save').off('click')
  $('.meta-popover .cancel').off('click')
  $('.meta-popover .remove').off('click')

@metaRemoveButtonClick = (object) ->
  uid = $(object).data('uid')
  $link = $('#' + uid)

  $link.attr('data-meta-text', 'null')
  if $('#meta' + uid).is(':checkbox')
    $link.html(", #{$link.attr('data-meta-pattern')}?")
  else
    $link.html($link.attr('data-meta-pattern'))

  saveMeta(uid)
  $link.attr('data-meta-id', '')
  $link.attr('data-meta-text', '')
  $link.popover('hide')
  $('.meta-popover .save').off('click')
  $('.meta-popover .cancel').off('click')
  $('.meta-popover .remove').off('click')

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
      $('.meta-text .save').off('click')
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
    currentYear = 2015

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
      $('.meta-academic-year .save').off('click')

    $('.meta-academic-year .cancel').on 'click', ->
      metaCancelLinkClick(this)
      return false
			
			
			
			
#Создание мета-блока с вариантами текста, связанного с приказом.
#@param uid

@initOrderReasonMultySelect = (uid) ->
  $this = $('#' + uid)
  required = ('true' == $this.attr('data-required'))

  options = $this.attr('data-reason-options').split('|')
  optionsText = $this.attr('data-reason-options-text').split('|')

  text = $this.attr('data-reason-text')
  isEmpty = ('' == text)
  if isEmpty
    text = $this.attr('data-reason-pattern')
  else
    text = $this.attr('data-reason-text')
  $this.html(text)

  div = $('<div>', {'class' : 'reason-popover reason-select reason-text-order', 'data-uid'  : uid})

  select = $('<select>', {'id' : 'reason' + uid, 'class': 'form-control', 'multiple': true, 'width' : required ? '234px' : '300px'})
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
    $('#reason'+$this.attr('id')+' option[value="'+$this.attr('data-reason-text')+'"]').prop('selected', true)
    $('.reason-select .save').on 'click', (event) ->
      selectedOption = $('#reason' + $(this).data('uid')).val()
      $('#' + $(this).data('uid')).attr('data-reason-text', selectedOption)
      saveReason($(this).data('uid'))
      $('#' + $(this).data('uid')).popover('hide')
      event.preventDefault()
      $('.reason-select .save').off('click')

    $('.reason-select .cancel').on 'click', (event) ->
      metaCancelLinkClick(this)
      event.preventDefault()
      
  if !required
    $('#' + uid + ' + div').css('max-width', 340)
    $('#' + uid + ' + div').css('width', 340)
    $('.meta-text .remove').on 'click', ->
      metaRemoveButtonClick(this)
  $('#reason' + uid).val($this.attr('data-reason-text'))


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


@saveReason = (uid) ->
  reason = $('#' + uid)

  #    Отправляем запрос на сервер.
  $.getJSON $('#matrixHQ').attr('href')+'ajax/orderreason', {
    'order'   : reason.attr('data-reason-order'),
    'reasons' : reason.attr('data-reason-text').split(',')
  }, (reasons) ->
    $('#' + uid).html(reasons.text)
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