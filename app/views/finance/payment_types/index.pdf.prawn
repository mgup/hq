prawn_document margin: [40.34645669291339, 35.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  pdf.text 'Стоимость обучения', size: 14, align: :center
  # data = [
  #     ['Факультет', 'Направление, специальность', 'Год поступления', 'Форма обучения', 'Курс', 'Год', 'Стоимость за год', 'Общая стоимость']
  # ]
  width = case @form
            when '101'
              50
            when '103'
              60
            else
              100
          end
  pdf.move_down 10
  raise @payment_types.inspect
  pdf.font_size 11 do
    @payment_types.each do |price|
      pdf.move_down 10
      pdf.font_size 13 do
        pdf.table [[price.speciality.faculty.abbreviation, price.speciality.full_name, "#{price.year}", price.form_of_study]],
                  cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
          column(0).width = 62
          column(2).width = 38
          column(3).width = width
        end
      end
      pdf.move_down 5
      price.sum[:by_year].each_with_index do |sum, index|
        pdf.text "#{index + 1}   #{price.year + index}   #{number_to_currency(sum[1])}"
      end
      pdf.stroke do
        pdf.move_down 3
        pdf.line_width 0.5
        pdf.horizontal_rule
      end
      pdf.move_down 3
      pdf.text "#{number_to_currency(price.sum[:total])}", style: :bold

      # data << [price.speciality.faculty.abbreviation, price.speciality.full_name, "#{price.year}", price.form_of_study,
      #          '',
      #          '',
      #          price.sum[:by_year].map{ |year, sum| "#{number_to_currency(sum)}\n" }.join,
      #          number_to_currency(price.sum[:total])]
    end
  end

  # pdf.font_size 11 do
  #   pdf.move_down 15
  #   pdf.table data, header: true
  # end
end
