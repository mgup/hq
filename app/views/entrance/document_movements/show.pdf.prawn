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

    if @document_movement.original
      # Уведомление о реорганизации
      pdf.start_new_page
      pdf.font 'PTSerif', size: 11 do
        pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
        pdf.text 'федеральное государственное бюджетное образовательное учреждение', align: :center
        pdf.text 'высшего профессионального образования', align: :center
        pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center, style: :bold
      end
      pdf.move_down 10
      pdf.font 'PTSerif', size: 15 do
        pdf.text 'Уведомление о реорганизации', align: :center, style: :bold
      end
      pdf.move_down 5
      pdf.font 'PTSerif', size: 13 do
        pdf.text 'Уважаемые обучающиеся Университета печати имени Ивана Федорова!', align: :center, style: :bold
      end
      pdf.move_down 8
      pdf.text '<b>В соответствии с приказом Министерства образования и науки Российской Федерации от 21 марта 2016 года № 261</b> уведомляем Вас о реорганизации федерального государственного бюджетного образовательного учреждения высшего образования «Московский государственный машиностроительный университет (МАМИ)» и федерального государственного бюджетного образовательного учреждения высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» в форме слияния с образованием на их основе <b>федерального государственного бюджетного образовательного учреждения высшего образования «Московский политехнический университет»</b>.', indent_paragraphs: 30, align: :justify, inline_format: true
      pdf.text 'Вам предлагается продолжить обучение в федеральном государственном бюджетном образовательном учреждении высшего образования <b>«Московский политехнический университет» (далее – Московский политехнический университет) с сохранением формы и условий обучения</b>, по которым Вы ранее обучались.', indent_paragraphs: 30, align: :justify, inline_format: true
      pdf.text 'О своем согласии или несогласии продолжить обучение в Московском политехническом университете с 01 сентября 2016 года просим сделать отметку на уведомлении.', indent_paragraphs: 30, align: :justify
      pdf.move_down 20
      pdf.text "Ректор#{' '*135}К.В. Антипов"
      pdf.image "#{Rails.root}/app/assets/images/sign.jpg", at: [173,410], scale: 0.6
      pdf.line_width = 1
      pdf.stroke do
        pdf.move_down 10
        pdf.horizontal_rule
      end
      pdf.move_down 35
      pdf.text "Ф.И.О. (полностью)#{' '*20}<u>#{@document_movement.entrant.full_name}</u>", inline_format: true
      pdf.text "Направление подготовки (с шифром)#{' '*5}<u>#{app.competitive_group_item.direction.description}</u>", inline_format: true
      pdf.move_down 2
      pdf.text '<b>С уведомлением ознакомлен (на):</b> ___________________ (_______________________________________)', inline_format: true
      pdf.font 'PTSerif', size: 8 do
        pdf.indent 240 do
          pdf.text "подпись#{' '*62}ФИО"
        end
      end
      pdf.move_down 10
      pdf.text 'О своем согласии или несогласии необходимо сделать отметку в уведомлении (поставить <b>X</b> или <b>V</b>)', inline_format: true, indent_paragraphs: 30, align: :justify
      pdf.move_down 5
      pdf.stroke_polygon [12,218], [12,208], [22,208], [22,218]
      pdf.text '<b>согласен</b> продолжить обучение в Московском политехническом университете. Прошу отчислить из Университета печати имени Ивана Федорова и зачислить в Московский политехнический университет в порядке перевода с 01.09.2016;', indent_paragraphs: 30, inline_format: true, align: :justify
      pdf.move_down 5
      pdf.stroke_polygon [12,168], [12,158], [22, 158], [22,168]
      pdf.text '<b>не согласен</b> продолжить обучение в Московском политехническом университете. Прошу отчислить из Университета печати имени Ивана Федорова с 01.09.2016.', indent_paragraphs: 30, inline_format: true, align: :justify
      pdf.move_down 25
      pdf.text "________________ (_________________________)#{' '*45}Дата «____» ___________ 20___ г."
      pdf.font 'PTSerif', size: 8 do
        pdf.indent 22 do
          pdf.text "подпись#{' '*44}ФИО"
        end
      end
      # Уведомление о реорганизации
    end
  end

  if @document_movement.moved && @document_movement.original_changed
  pdf.start_new_page
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

      # Уведомление о реорганизации
      pdf.start_new_page
      pdf.font 'PTSerif', size: 11 do
        pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
        pdf.text 'федеральное государственное бюджетное образовательное учреждение', align: :center
        pdf.text 'высшего профессионального образования', align: :center
        pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center, style: :bold
      end
      pdf.move_down 10
      pdf.font 'PTSerif', size: 15 do
        pdf.text 'Уведомление о реорганизации', align: :center, style: :bold
      end
      pdf.move_down 5
      pdf.font 'PTSerif', size: 13 do
        pdf.text 'Уважаемые обучающиеся Университета печати имени Ивана Федорова!', align: :center, style: :bold
      end
      pdf.move_down 8
      pdf.text '<b>В соответствии с приказом Министерства образования и науки Российской Федерации от 21 марта 2016 года № 261</b> уведомляем Вас о реорганизации федерального государственного бюджетного образовательного учреждения высшего образования «Московский государственный машиностроительный университет (МАМИ)» и федерального государственного бюджетного образовательного учреждения высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» в форме слияния с образованием на их основе <b>федерального государственного бюджетного образовательного учреждения высшего образования «Московский политехнический университет»</b>.', indent_paragraphs: 30, align: :justify, inline_format: true
      pdf.text 'Вам предлагается продолжить обучение в федеральном государственном бюджетном образовательном учреждении высшего образования <b>«Московский политехнический университет» (далее – Московский политехнический университет) с сохранением формы и условий обучения</b>, по которым Вы ранее обучались.', indent_paragraphs: 30, align: :justify, inline_format: true
      pdf.text 'О своем согласии или несогласии продолжить обучение в Московском политехническом университете с 01 сентября 2016 года просим сделать отметку на уведомлении.', indent_paragraphs: 30, align: :justify
      pdf.move_down 20
      pdf.text "Ректор#{' '*135}К.В. Антипов"
      pdf.image "#{Rails.root}/app/assets/images/sign.jpg", at: [173,410], scale: 0.6
      pdf.line_width = 1
      pdf.stroke do
        pdf.move_down 10
        pdf.horizontal_rule
      end
      pdf.move_down 35
      pdf.text "Ф.И.О. (полностью)#{' '*20}<u>#{@document_movement.entrant.full_name}</u>", inline_format: true
      pdf.text "Направление подготовки (с шифром)#{' '*5}<u>#{app.competitive_group_item.direction.description}</u>", inline_format: true
      pdf.move_down 2
      pdf.text '<b>С уведомлением ознакомлен (на):</b> ___________________ (_______________________________________)', inline_format: true
      pdf.font 'PTSerif', size: 8 do
        pdf.indent 240 do
          pdf.text "подпись#{' '*62}ФИО"
        end
      end
      pdf.move_down 10
      pdf.text 'О своем согласии или несогласии необходимо сделать отметку в уведомлении (поставить <b>X</b> или <b>V</b>)', inline_format: true, indent_paragraphs: 30, align: :justify
      pdf.move_down 5
      pdf.stroke_polygon [12,218], [12,208], [22,208], [22,218]
      pdf.text '<b>согласен</b> продолжить обучение в Московском политехническом университете. Прошу отчислить из Университета печати имени Ивана Федорова и зачислить в Московский политехнический университет в порядке перевода с 01.09.2016;', indent_paragraphs: 30, inline_format: true, align: :justify
      pdf.move_down 5
      pdf.stroke_polygon [12,168], [12,158], [22, 158], [22,168]
      pdf.text '<b>не согласен</b> продолжить обучение в Московском политехническом университете. Прошу отчислить из Университета печати имени Ивана Федорова с 01.09.2016.', indent_paragraphs: 30, inline_format: true, align: :justify
      pdf.move_down 25
      pdf.text "________________ (_________________________)#{' '*45}Дата «____» ___________ 20___ г."
      pdf.font 'PTSerif', size: 8 do
        pdf.indent 22 do
          pdf.text "подпись#{' '*44}ФИО"
        end
      end
      # Уведомление о реорганизации

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
      text << "прошу перенести комплект документов в дело № #{@document_movement.to_application.number}."
      pdf.text text.join(' '), align: :justify, indent_paragraphs: 20

      pdf.move_down 80

      pdf.text l(@document_movement.created_at.to_date) + (' ' * 110) + '_______________________'

    end
  end


end
