prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf
  pdf.text 'Регистрационный журнал', align: :center
  data = [
      ['№', 'Дата приёма документов', 'Фамилия, имя, отчество', 'Регистрационный номер', 'Индекс, адрес, телефон', 'Возврат документов (подпись или номер почтовой квитанции)']
  ]
  @applications.register_information.each do |row|
    data << row
  end
  pdf.font_size 7 do
    pdf.table data, header: true do
        column(0).width = 25
        column(1).width = 70
        column(5).width = 80
    end
  end
end