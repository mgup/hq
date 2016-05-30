prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  if @document_movement.original_changed
    app = @document_movement.from_application
    pdf.text 'Председателю приемной комиссии', indent_paragraphs: 300
    pdf.text 'МГУП имени Ивана Федорова', indent_paragraphs: 300
    pdf.text 'Антипову К. В.', indent_paragraphs: 300
    pdf.move_down 10
    pdf.text "поступаю#{@document_movement.entrant.male? ? 'щего' : 'щей'}", indent_paragraphs: 300
    pdf.text "личное дело № #{app.number}", indent_paragraphs: 300

    pdf.move_down 60

    pdf.text 'ЗАЯВЛЕНИЕ', align: :center

    pdf.move_down 50

    text = ["Я, #{@document_movement.entrant.full_name}, "]

    if @document_movement.original
      text << "подтверждаю согласие на зачисление на направление подготовки #{app.competitive_group_item.direction.description}, профиль #{app.profile ? app.profile.name : 'не указан' }, #{app.education_form_name} форма обучения, #{app.is_payed ? 'договорная' : 'бюджетная'} основа обучения, предоставляю оригинал документа об образовании."
    else
      text << "отзываю согласие на зачисление на направление подготовки #{app.competitive_group_item.direction.description}, профиль #{app.profile ? app.profile.name : 'не указан' }, #{app.education_form_name} форма обучения, #{app.is_payed ? 'договорная' : 'бюджетная'} основа обучения, прошу выдать оригинал документа об образовании."
    end

    pdf.text text.join(' '), align: :justify, indent_paragraphs: 20

    pdf.move_down 80

    pdf.text l(@document_movement.created_at.to_date) + (' ' * 110) + '_______________________'
  end

  if @document_movement.moved
    if @document_movement.original
      app = @document_movement.to_application
      pdf.text 'Председателю приемной комиссии', indent_paragraphs: 300
      pdf.text 'МГУП имени Ивана Федорова', indent_paragraphs: 300
      pdf.text 'Антипову К. В.', indent_paragraphs: 300
      pdf.move_down 10
      pdf.text "поступаю#{@document_movement.entrant.male? ? 'щего' : 'щей'}", indent_paragraphs: 300
      pdf.text "личное дело № #{app.number}", indent_paragraphs: 300

      pdf.move_down 60

      pdf.text 'ЗАЯВЛЕНИЕ', align: :center

      pdf.move_down 50

      text = ["Я, #{@document_movement.entrant.full_name}, "]
      text << "подтверждаю согласие на зачисление на направление подготовки #{app.competitive_group_item.direction.description}, профиль #{app.profile ? app.profile.name : 'не указан' }, #{app.education_form_name} форма обучения, #{app.is_payed ? 'договорная' : 'бюджетная'} основа обучения, предоставляю оригинал документа об образовании."

      pdf.text text.join(' '), align: :justify, indent_paragraphs: 20

      pdf.move_down 80

      pdf.text l(@document_movement.created_at.to_date) + (' ' * 110) + '_______________________'


      pdf.start_new_page
      app = @document_movement.from_application
      pdf.text 'Председателю приемной комиссии', indent_paragraphs: 300
      pdf.text 'МГУП имени Ивана Федорова', indent_paragraphs: 300
      pdf.text 'Антипову К. В.', indent_paragraphs: 300
      pdf.move_down 10
      pdf.text "поступаю#{@document_movement.entrant.male? ? 'щего' : 'щей'}", indent_paragraphs: 300
      pdf.text "личное дело № #{app.number}", indent_paragraphs: 300

      pdf.move_down 60

      pdf.text 'ЗАЯВЛЕНИЕ', align: :center

      pdf.move_down 50

      text = ["Я, #{@document_movement.entrant.full_name}, "]
      text << "отзываю согласие на зачисление на направление подготовки #{app.competitive_group_item.direction.description}, профиль #{app.profile ? app.profile.name : 'не указан' }, #{app.education_form_name} форма обучения, #{app.is_payed ? 'договорная' : 'бюджетная'} основа обучения, прошу выдать оригинал документа об образовании."

      pdf.text text.join(' '), align: :justify, indent_paragraphs: 20

      pdf.move_down 80

      pdf.text l(@document_movement.created_at.to_date) + (' ' * 110) + '_______________________'
    else
      pdf.text 'Председателю приемной комиссии', indent_paragraphs: 300
      pdf.text 'МГУП имени Ивана Федорова', indent_paragraphs: 300
      pdf.text 'Антипову К. В.', indent_paragraphs: 300
      pdf.move_down 10
      pdf.text "поступаю#{@document_movement.entrant.male? ? 'щего' : 'щей'}", indent_paragraphs: 300
      pdf.text "личное дело № #{app.number}", indent_paragraphs: 300

      pdf.move_down 60

      pdf.text 'ЗАЯВЛЕНИЕ', align: :center

      pdf.move_down 50

      text = ["Я, #{@document_movement.entrant.full_name}, "]
      text << "прошу перенести комплект документов в дело № #{@document_movement.to_application.number}."
      pdf.text text.join(' '), align: :justify, indent_paragraphs: 20

      pdf.move_down 80

      pdf.text l(@document_movement.created_at.to_date) + (' ' * 110) + '_______________________'

    end
  end


end
