prawn_document margin: [40.34645669291339, 35.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  pdf.text 'Стоимость обучения', size: 14, align: :center
  # data = [
  #     ['Факультет', 'Направление, специальность', 'Год поступления', 'Форма обучения', 'Курс', 'Год', 'Стоимость за год', 'Общая стоимость']
  # ]
  @payment_types.each do |price|
    data << [price.speciality.faculty.abbreviation, price.speciality.full_name, "#{price.year}", price.form_of_study,
             '',
             '',
             price.sum[:by_year].map{ |year, sum| "#{number_to_currency(sum)}\n" }.join,
             number_to_currency(price.sum[:total])]
  end

  pdf.font_size 11 do
    pdf.move_down 15
      pdf.table data, header: true
    end
  end
