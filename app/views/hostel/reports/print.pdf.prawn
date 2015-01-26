prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Акт проверки №#{@report.id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
 render 'pdf/font', pdf: pdf
   pdf.font_size = 10
   pdf.text "от «___» ________________ #{Study::Discipline::CURRENT_STUDY_TERM == 1 ? Study::Discipline::CURRENT_STUDY_YEAR : Study::Discipline::CURRENT_STUDY_YEAR+1} г."
   pdf.move_down 5
   pdf.text 'Место составления: г. Москва, ул. ________________________________________________________________________________'
   pdf.move_down 5
   pdf.text 'Время составления: ________________'

  pdf.move_down 25
  pdf.text 'АКТ ПРОВЕРКИ', align: :center, style: :bold
  pdf.text 'состояния квартиры в общежитии МГУП имени Ивана Федорова', align: :center, style: :bold
  pdf.text '(СПРАВКА О РЕЗУЛЬТАТАХ ПРОВЕРКИ)', align: :center, style: :bold
  pdf.move_down 25

  pdf.text "<strong>Дата проверки:</strong> «<u>#{l @report.date, format: '%d'}</u>» <u>#{l @report.date, format: '%B'}</u> #{l @report.date, format: '%Y'} г.", inline_format: true
  pdf.move_down 5
  pdf.text "<strong>Время проверки:</strong> «<u>#{l @report.time, format: '%H:%M'}</u>».", inline_format: true

  pdf.move_down 20
  pdf.text "Настоящий акт (справка) составлен(а) по результатам проверки квартиры (блока) № <u>#{@report.flat.number}</u> общежития МГУП имени Ивана Федорова, расположенного по адресу: ", inline_format: true
  pdf.move_down 5
  pdf.text "г. Москва, #{@report.flat.hostel.address};"
  pdf.move_down 5
  pdf.text 'проживающие:'
  @report.flat.residents.each do |person|
  pdf.move_down 2
  pdf.text "#{person.short_name}, #{person.students.first.group.name}"
  end
  pdf.move_down 10
  pdf.text "<strong>Проверка проведена</strong> в соответствии с Уставом федерального государственного бюджетного образовательного учреждения высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (п. 6.7, п.6.12), Положением о студенческом общежитии федерального государственного бюджетного образовательного учреждения высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (п. 12, п. 16) и Правилами внутреннего распорядка в студенческом общежитии Московского государственного университета печати имени Ивана Федорова (п. 4.3).", inline_format: true
  pdf.move_down 20
  if @report.offenses.empty?
     pdf.text "<strong><u>В ходе проверки нарушений не обнаружено.</u></strong>", inline_format: true
  else
    pdf.text "<strong><u>В ходе проверки выявлены нарушения</u></strong>", inline_format: true
    pdf.move_down 5
    @report.report_offenses.each_with_index do |ro, index|
     if ro.persons.empty?
       x = ro.offense.description
       x.slice! ' (для случая, если нарушитель не установлен)'
      pdf.text "#{index + 1}. #{x} #{(ro.rooms.empty? ? 'в местах общего пользования' : 'в жилом помещении')}#{ (', а именно: <u>' + ro.details + '</u>') if ro.details? }.", inline_format: true
      unless ro.rooms.empty?
        pdf.text "Комнат#{ro.rooms.length > 1 ? 'ы' : 'а'}, в котор#{ro.rooms.length > 1 ? 'ых' : 'ой'} зафиксирован факт нарушения:"
      else
        pdf.text 'Нарушители не установлены.'
      end
     else
       x = ro.offense.description
       x.slice! ' (для случая, если нарушитель установлен)'
     pdf.text "#{index + 1}. #{x}#{ (', а именно: <u>' + ro.details + '</u>,') if ro.details? } и установлен#{ro.persons.length > 1 ? 'ы' : ''} следующи#{ro.persons.length > 1 ? 'е' : 'й'} нарушител#{ro.persons.length > 1 ? 'и' : 'ь'}:", inline_format: true
     end
        ro.rooms.each do |room|
          pdf.indent 50 do
            pdf.text room.description
          end
        end
        ro.persons.each do |person|
          pdf.indent 50 do
            pdf.text "#{person.short_name}, #{person.students.first.group.name}"
          end
        end
      pdf.move_down 5
    end
  end

  pdf.move_down 40
  #pdf.text "Настоящий акт составлен в двух экземплярах, имеющих равную юридическую силу."
  #pdf.move_down 20
  unless @report.applications.empty?
    pdf.text "Приложения: 1. #{@report.applications.first.name}#{' '*(160 - pdf.font.compute_width_of(@report.applications.first.name)/pdf.font.compute_width_of(' ')) } на <u>#{@report.applications.first.papers ? @report.applications.first.papers : '__'}</u> л.", inline_format: true
    @report.applications.drop(1).each_with_index do |ap, index|
      pdf.indent 66 do
        pdf.text "#{index+2}. #{ap.name}#{' '*(160 - pdf.font.compute_width_of(ap.name)/pdf.font.compute_width_of(' ')) } на <u>#{ap.papers ? ap.papers : '__'}</u> л.", inline_format: true
      end
    end
  end
  pdf.move_down 20
  pdf.text "<strong>Члены комиссии</strong>                                                                                                                     _______________ (_______________)", inline_format: true
  pdf.font_size 7 do
     pdf.indent 385 do
       pdf.text 'подпись                   расшифровка'
     end
  end
  pdf.move_down 10
  pdf.indent 370 do
    pdf.text '_______________ (_______________)'
  end
  pdf.font_size 7 do
    pdf.indent 385 do
      pdf.text 'подпись                   расшифровка'
    end
  end
  pdf.move_down 10
    pdf.indent 370 do
      pdf.text '_______________ (_______________)'
    end
    pdf.font_size 7 do
      pdf.indent 385 do
        pdf.text 'подпись                   расшифровка'
      end
    end
  pdf.move_down 20
  #pdf.text "<strong>С актом проверки ознакомлен:</strong>", inline_format: true
end