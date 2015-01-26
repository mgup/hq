prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  pdf.text 'Председателю приемной комиссии', indent_paragraphs: 300
  pdf.text 'МГУП имени Ивана Федорова', indent_paragraphs: 300
  pdf.text 'Антипову К. В.', indent_paragraphs: 300
  pdf.text "от абитуриент#{@document_movement.entrant.male? ? 'а' : 'ки'}", indent_paragraphs: 300
  pdf.text "#{@document_movement.entrant.short_name} (#{@document_movement.from_application.number})", indent_paragraphs: 300

  pdf.move_down 40

  pdf.text 'заявление.', align: :center

  pdf.move_down 40

  text = []
  if @document_movement.original_changed
    if @document_movement.original
      text << 'Прошу принять подлинник документа об образовании взамен ранее предоставленной копии.'
    else
      text << 'Прошу выдать подлинник документа об образовании.'
    end
  end

  if @document_movement.moved
    if @document_movement.original
      text << "Прошу переложить подлинник документа об образовании в дело № #{@document_movement.to_application.number}."
    else
      text << "Прошу перенести комплект документов в дело № #{@document_movement.to_application.number}."
    end
  end

  pdf.text text.join(' '), align: :justify, indent_paragraphs: 20

  pdf.move_down 60

  pdf.text '_______________________' + (' ' * 20) + l(@document_movement.created_at.to_date), align: :right
end