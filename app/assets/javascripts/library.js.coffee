#readers = new Array()
#c = null
#$ ->
#  showCards = (selectedReaders) ->
#    canvas = $('#canvas_for_library_card')
#    context = canvas.getContext('2d')
#    context.font = '17px Times New Roman'
#
#    if selectedReaders == null
#      context.clearRect(0, 0, canvas.width, canvas.height)
#      return
#
#    readers1 = new Array()
#    readers2 = new Array()
#    barcodes = new Array()
#    i = -248
#    ((id, rdr_id) ->
#      i += 248;
#      rdr_name = readers[rdr_id]
#      readers1[i] = new Image()
#      readers2[i] = new Image()
#      readers1[i].src = "/img/library/reader1.gif"
#      readers2[i].src = "/img/library/reader2.gif"
#
#      readers1[i].onload = ->
#        context.drawImage(readers1[i], 2, (2 + i))
#        context.fillText(fio[0], 210, (90 + i))
#        context.fillText(fio[1], 210, (105 + i))
#        context.fillText(fio[2], 210, (122 + i))
#
#      readers2[i].onload = ->
#        context.drawImage(readers2[i], 370, (2 + i))
#
#      barcodes[i] = new Image()
#      barcodes[i].src = '/library/card/barcode/id/' + rdr_id
#      fio = rdr_name.split(' ')
#
#      barcodes[i].onload = ->
#        context.drawImage(barcodes[i], 150, (150 + i))
#    ) for x in selectedReaders
#    c = canvas


#  $('#name').ajaxChosen({
#      no_results_text: "Результатов не найдено",
#      method: 'POST',
#      url: '/library/card/findforprint',
#      dataType: 'json'
#    }, (data) ->
#      terms = {}
#      data.each (i,val) ->
#        terms[i] = val
#        readers[i] = val
#      return terms
#  )

#  if $('#canvas_for_library_card').length > 0
#    showCards($(this).val())
#
#  $('#print_library_card').submit (e) ->
#    img = c.toDataURL("image/png")
#    document.write('<img src="'+img+'"/>')
#    window.print()
#    location.href = '/library/card/print'
#    return false
