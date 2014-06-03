#readers = new Array()
#c = null
$ ->
	showCards = (name, rdr_id) ->
		canvas = $('#canvas_for_library_card').get(0)
		context = canvas.getContext('2d')
		context.font = '17px Times New Roman'	  
		readers1 = new Image()
		readers2 = new Image()
		readers1.src = '/assets/library/reader1.gif'
		readers2.src = '/assets/library/reader2.gif'
		fio = name.split(' ')
		readers1.onload = ->
			canvas.width = readers1.width * 2.5
			canvas.height = readers1.height + 10
			context.drawImage(readers1, 2, 2)
			context.fillText(fio[0], 210, 90)
			context.fillText(fio[1], 210, 105)
			context.fillText(fio[2], 210, 122)
		readers2.onload = ->
		  context.drawImage(readers2, 370, 2)
    barcodes = new Image()
    barcodes.src = '/assets/library/barcode.png'
    barcodes.onload = ->
      context.drawImage(barcodes, 165, 140)


	if $('#canvas_for_library_card').length > 0
    	showCards($('#library_student').data('name'), $('#library_student').data('value'))

