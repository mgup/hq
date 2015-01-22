$ ->
  $ ->
    root = $('#matrixHQ').attr('href')
    orderDiv = $('div#create_order')
    orderTable = $('div#create_order table tbody')
    orderDiv.hide()

#    Адрес, куда идет обращение скрипта при паджинации.
    href = $('div#ajax_content').data('href')

#    Текущая страница.
    currentPage = $('ul.pagination li.active a').text()
    if 'undefined' == typeof(currentPage)
      currentPage = 1

#    Функция обработки входящих данных в урле.
    getData = ->
      query = location.href
      vars = query.split("&")
      $('#createOrderWithStudents').attr('href', (root + 'office/orders?template=' + $('#createOrderWithStudents').data('value')))
      for i in vars
        pair = i.split("=")

#      Если у нас в урле есть студенты,
#      которых мы включаем в приказ, то
#      получаем их данные и включаем в
#      табличку с созданием приказа.

        if pair[0] == 'exception[]'
          $.get root+'ajax/orderstudent',
            id: pair[1]
            (data) ->
              row = '<tr><td class="id">' + data.id + '</td>' + '<td>' + data.fname + '</td>' + '<td>' + data.iname + '</td>' + '<td>' + data.oname + '</td>' + '<td>' + data.faculty + '</td>' + '<td>' + data.group + '</td>' + '<td class="image">' + '<a class="btn btn-default orderremove" href="#">' + '<span class="glyphicon glyphicon-arrow-down"></span>' + '</a></td></tr>'
              orderTable.append(row)
              checkCount()
          $('#createOrderWithStudents').attr('href', ($('#createOrderWithStudents').attr('href') + "&exception[]=#{pair[1]}"))

#    Если у нас есть элемент - добавление студентов в приказ,
#    то смотрим его, считаем в нем количество студентов,
#    если оно 0, то скрываем.

    checkCount = ->
      l = orderTable.find('tr').length
      if l == 0 then orderDiv.hide() else orderDiv.show()

    setCreateOrder = ->
      $('a.orderadd').click (e) ->
        tr = $(this).closest('tr')
        img = tr.find('span')
        img.removeClass('glyphicon-arrow-up')
        img.addClass('glyphicon-arrow-down')
        $(this).removeClass('orderadd')
        $(this).addClass('orderremove')
        orderTable.append(tr)
        processData()
        e.preventDefault()
        checkCount()

      $('a').click ->
        $('a.orderremove').click (e) ->
          e.preventDefault()
          tr = $(this).closest('tr')
          tr.remove()
          location.href = processData()
          checkCount()

#    Обработка данных и помещение их в адресную строку.

    processData = (url = null) ->
      data = $('#formstudentsearch').serialize()

      template = ''
      if $('#order_template')[0]
        template = 'template=' + $('#order_template option:selected').val() + '&'

#      Добавляем в дату массив исключений (если мы создаем приказ).
      exceptions = ""
      $('div#create_order table>tbody>tr>td:nth-child(1)').each ->
        exceptions = exceptions + '&exception[]=' + $(this).text()
      if null == url
        currentPage = 1 if currentPage == ''
        totalData = href + currentPage + '/?' + template + data + exceptions
        history.pushState( null, null, totalData)
        $('#createOrderWithStudents').attr('href', (root+'office/orders?'+template+exceptions))
      else
        totalData = url

      return totalData

#    Кнопка "Следующая".

    next = ->
      currentPage++

#    Кнопка "Предыдущая".

    prev = ->
      if currentPage > 1
        currentPage--

    setListeners = ->
      $('a.print').click ->
        data = $('#formstudentsearch').serialize()
        location.href = href + 'print/?' + data + '&print=1'

      $('button[type=submit],input[type=submit]').click (e) ->
        e.preventDefault()
        location.href = processData()


      $('ul.pagination li.page').click (e) ->
        e.preventDefault()
        currentPage = $(this).find('a').text()
        location.href = processData()


      $('ul.pagination li.next').click (e) ->
        unless $(this).hasClass('disabled')
          e.preventDefault()
          next()
          location.href = processData()


      $('ul.pagination li.prev').click (e) ->
        unless !$(this).hasClass('disabled')
          e.preventDefault()
          prev()
          location.href = processData()


#    Обработка нажатия на сброс фильтров.

      $('.form_reset').click (e) ->
        e.preventDefault()
        template = "template=" + $('#order_template option:selected').val()
        exceptions = ""
        $('div#create_order table>tbody>tr>td:nth-child(1)').each ->
          exceptions = exceptions + "&exception[]=" + $(this).text()
        location.href = href+ currentPage + '/?&' + template + exceptions


      $('#order_template').change ->
        location.href = processData()

    if $('#formstudentsearch')[0]
      setListeners()
      setCreateOrder()
      getData()