def find_form_and_payment(f, p)

  @form = case f
                when :z
                  'заочная форма'
                when :oz
                  'очно-заочная форма'
                else
                  'очная форма'
                end

  @source = case p
            when :paid
              'с оплатой обучения'
            else
              'бюджетные места'
            end
end

prawn_document margin: [28.34645669291339, 35.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf
  
  # raise 'csgdfjh'
  
  i = 0
  applications = @apps.group_by_form_payment_and_direction
  [:not_paid, :paid].each do |p|
    [:o, :oz, :z].each do |f|
      if applications[p][f].empty?
        next
      else
        applications[p][f].each do |direction, apps|
          pdf.start_new_page unless i == 0
          i += 1
          pdf.text "Регистрационный журнал на #{params[:date]}", align: :center, size: 10

          data = [
            ['№', 'Дата приёма документов', 'Фамилия, имя, отчество', 'Регистрационный номер', 'Индекс, адрес, телефон', 'Возврат документов (подпись или номер почтовой квитанции)']
          ]
          
          apps.each_with_index do |application, index|
            data << [index + 1, (I18n.l application.created_at, format: '%d.%m.%Y'), application.entrant.full_name, application.number, application.entrant.contacts, '']
          end
          
          find_form_and_payment(f, p)
          pdf.font_size 8 do
            pdf.move_down 8
            pdf.text "Направление подготовки (специальность): <strong>#{direction.name}</strong>", inline_format: true
            pdf.text "Форма обучения: <strong>#{@form}</strong>", inline_format: true
            pdf.text "Основа обучения: <strong>#{@source}</strong>", inline_format: true
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
      end
    end
  end
  

  
end