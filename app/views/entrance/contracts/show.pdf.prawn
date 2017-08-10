prawn_document margin: [56.692913386, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  render 'contract', pdf: pdf

  pdf.start_new_page

  render 'contract', pdf: pdf

  if @contract.trilateral? || @contract.trilateral_with_organization?
    pdf.start_new_page

    render 'contract', pdf: pdf
  end

  pdf.start_new_page

  pdf.font_size 12
  pdf.text "Уважаем#{@entrant.male? ? 'ый' : 'ая'}, #{@entrant.full_name}."

  pdf.move_down 20

  pdf.font_size 14
  pdf.text "Ваш личный номер студента — #{@contract.student_id}.", style: :bold

  pdf.move_down 10

  pdf.font_size 12
  pdf.text 'Он необходим для оплаты обучения через терминалы СДМ-Банка.'
  pdf.text '1) Подойдите к терминалу «ПЛАТ-ФОРМА», убедитесь, что терминал находится в рабочем состоянии. Прикоснитесь к монитору или выберите быструю клавишу с логотипом МГУП, расположенным  внизу экранного меню.', align: :justify
  pdf.text '2) На появившемся экране выберите иконку «Оплата услуг».', align: :justify
  if @entrant.ioo == true
    pdf.text '3) Выберите иконку «Оплата дистанционного обучения».', align: :justify
  else
    pdf.text '3) Выберите иконку «Оплата образовательных услуг».', align: :justify
  end
  pdf.text '4) Выберите иконку «МГУП им. Ивана Федорова».', align: :justify
  pdf.text "5) Введите ваш личный номер студента #{@contract.student_id}.", align: :justify
  pdf.text '6) Введите свои паспортные данные для подтверждения.', align: :justify
  pdf.text '7) Проверьте верность всех ваших данных (ФИО, ФИО плательщика), которые появятся на экране терминала после ввода личного номера. При наличии каких-либо несовпадений следует обратиться в дирекцию вашего института или Отдел информационных систем (кабинет 1320).', align: :justify
  pdf.text '8) C помощью панели ввода наберите ту сумму, которую необходимо оплатить
 согласно договору и графику платежей, и нажмите кнопку «Принять».', align: :justify
  pdf.text '9) Внесите необходимую сумму и нажмите кнопку «Оплатить» после внесения платежа. Будет выдан чек «Плат-Форма».', align: :justify
  pdf.text '10) В том случае если сумма платежа превышает 15 000 руб., будет выведено информационное окно, и в рамках одной сессии должно быть сделано несколько платежей.', align: :justify
  pdf.text '11) Для этого нужно внести максимальную сумму платежа и нажать кнопку «Оплатить и произвести повторный платёж с теми же реквизитами». После каждого внесения платежа будет выдан чек «Плат-Форма».', align: :justify

  pdf.start_new_page

  pdf.text 'Председателю приемной комиссии', indent_paragraphs: 300
  pdf.text 'МГУП имени Ивана Федорова', indent_paragraphs: 300
  pdf.text 'Антипову К.В.', indent_paragraphs: 300
  pdf.move_down 10
  pdf.text "поступаю#{@entrant.male? ? 'щего' : 'щей'}", indent_paragraphs: 300
  pdf.text "личное дело № #{@application.number}", indent_paragraphs: 300

  pdf.move_down 60

  pdf.text 'ЗАЯВЛЕНИЕ', align: :center

  pdf.move_down 50

  text = ["Я, #{@entrant.full_name}, "]
  text << "подтверждаю согласие на зачисление на направление подготовки #{@application.competitive_group_item.direction.description}, профиль #{@application.profile ? @application.profile.name : 'не указан' }, #{@application.education_form_name} форма обучения, договорная основа обучения, предоставляю копию документа об образовании."

  pdf.text text.join(' '), align: :justify, indent_paragraphs: 20

  pdf.move_down 80

  pdf.text l(@contract.created_at.to_date) + (' ' * 110) + '_______________________'

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
  pdf.image "#{Rails.root}/app/assets/images/sign.jpg", at: [173,380], scale: 0.6
  pdf.line_width = 1
  pdf.stroke do
    pdf.move_down 10
    pdf.horizontal_rule
  end
  pdf.move_down 35
  pdf.text "Ф.И.О. (полностью)#{' '*20}<u>#{@entrant.full_name}</u>", inline_format: true
  pdf.text "Направление подготовки (с шифром)#{' '*5}<u>#{@application.competitive_group_item.direction.description}</u>", inline_format: true
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
  pdf.stroke_polygon [12,189], [12,179], [22, 179], [22,189]
  pdf.text '<b>согласен</b> продолжить обучение в Московском политехническом университете. Прошу отчислить из Университета печати имени Ивана Федорова и зачислить в Московский политехнический университет в порядке перевода с 01.09.2016;', indent_paragraphs: 30, inline_format: true, align: :justify
  pdf.move_down 5
  pdf.stroke_polygon [12,140], [12,130], [22, 130], [22,140]
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
