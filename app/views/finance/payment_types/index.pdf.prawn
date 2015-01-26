prawn_document margin: [40.34645669291339, 35.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  if params[:faculty] && params[:faculty] != ''
    faculties = [Department.find(params[:faculty])]
  else
    faculties = Department.faculties
  end
  # data = [
  #     ['Факультет', 'Направление, специальность', 'Год поступления', 'Форма обучения', 'Курс', 'Год', 'Стоимость за год', 'Общая стоимость']
  # ]
  faculties.each_with_index do |faculty, i|
    if i > 0
      pdf.start_new_page
    end
    pdf.text "Стоимость обучения на #{faculty.abbreviation}", size: 14, align: :center
    width = case @form
              when '101'
                50
              when '103'
                60
              else
                100
            end
    pdf.move_down 10

    pdf.font_size 11 do
      @payment_types.from_faculty(faculty.id).order('finance_payment_type_form').each do |price|
        pdf.move_down 10
        pdf.font_size 13 do
          pdf.table [[price.speciality.full_name, "#{price.year}", price.form_of_study]],
                    cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
            column(1).width = 38
            column(2).width = width
          end
        end
        pdf.move_down 5
        pdf.table [[price.sum[:by_year].each_with_index.map{|sum, index| "#{index + 1}   #{price.year + index}   #{number_to_currency(sum[1])}\n"}.join,
                   "#{number_to_currency(price.sum[:total])}"]],
                    cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
          column(0).width = 150
          column(1).style valign: :center, size: 14, style: :bold
        end

        # pdf.stroke do
        #   pdf.move_down 3
        #   pdf.line_width 0.5
        #   pdf.horizontal_rule
        # end
        # pdf.move_down 3
        # pdf.text "#{number_to_currency(price.sum[:total])}", style: :bold

      # data << [price.speciality.faculty.abbreviation, price.speciality.full_name, "#{price.year}", price.form_of_study,
      #          '',
      #          '',
      #          price.sum[:by_year].map{ |year, sum| "#{number_to_currency(sum)}\n" }.join,
      #          number_to_currency(price.sum[:total])]
      end
    end
  end
  # pdf.font_size 11 do
  #   pdf.move_down 15
  #   pdf.table data, header: true
  # end
end
