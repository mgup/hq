prawn_document margin: [56.692913386, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  render 'contract', pdf: pdf

  pdf.start_new_page

  render 'contract', pdf: pdf

  if @contract.trilateral?
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
  pdf.text 'Антипову К. В.', indent_paragraphs: 300
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

end
