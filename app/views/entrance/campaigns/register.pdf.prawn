prawn_document margin: [28.34645669291339, 35.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf
  if params[:date] == ''
    pdf.text 'Регистрационный журнал', align: :center, size: 10
  else
    pdf.text "Регистрационный журнал на #{params[:date]}", align: :center, size: 10
  end
  data = [
      ['№', 'Дата приёма документов', 'Фамилия, имя, отчество', 'Регистрационный номер', 'Индекс, адрес, телефон', 'Возврат документов (подпись или номер почтовой квитанции)']
  ]
  @applications.register_information.each do |row|
    data << row
  end
  pdf.font_size 8 do
    pdf.move_down 8
    pdf.text "Направление подготовки (специальность): <strong>#{@direction ? @direction.name : 'все направления'}</strong>", inline_format: true
    pdf.text "Форма обучения: <strong>#{@form.name.mb_chars.downcase.to_s}</strong>", inline_format: true
    pdf.text "Основа обучения: <strong>#{@source.name.mb_chars.downcase.to_s}</strong>", inline_format: true
  end
  pdf.font_size 7 do
    pdf.move_down 8
    pdf.table data, header: true do
        column(0).width = 25
        column(1).width = 70
        column(3).width = 70
        column(5).width = 80
    end

    pdf.number_pages 'Подпись ответственного секретаря приёмной комиссии: __________________ / __________________ /', at: [pdf.bounds.left + 200, 12]
  end
end