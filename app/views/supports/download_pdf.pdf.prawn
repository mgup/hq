prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: 'Заявление на материальную помощь.pdf',
               page_size: 'A4', page_layout: :portrait do |pdf|
 render 'pdf/font', pdf: pdf
 support = @student.supports.last
   pdf.font_size = 10
   pdf.indent 300 do
    pdf.text 'Ректору федерального государственного'
    pdf.text 'бюджетного учреждения высшего'
    pdf.text 'профессионального образования'
    pdf.text '«Московский государственный университет'
    pdf.text 'печати имени Ивана Федорова»'
    pdf.text 'К. В. Антипову'
    pdf.text "от студента #{@student.group.course} курса #{study_form_name(@student.group.form, :rp)} формы бюджетной основы обучения"
    pdf.text "#{@student.group.speciality.faculty.abbreviation}, группы #{@student.group.name}"
    pdf.font 'PTSerif', size: 11, style: :bold do
      pdf.text "#{@student.person.full_name(:rp)},"
    end
    pdf.text "#{support.birthday}"
    pdf.text "паспорт #{support.series} #{support.number} выдан #{support.date} #{support.department},"
    pdf.text "адрес регистрации: #{support.address}, #{support.phone}"
  end
  pdf.move_down 25
  pdf.text "ЗАЯВЛЕНИЕ №#{support.id}", align: :center
  pdf.move_down 10
  pdf.text 'о выплате материальной помощи', align: :center
  pdf.move_down 25
  cause = ''
  support.options.each do |option|
    cause << (@student.person.male? ? option.cause.pattern : (option.cause.patternf == nil ? option.cause.pattern : option.cause.patternf))
    cause << ', '
  end
  cause = cause[0..-3]
  pdf.text "Прошу Вас предоставить мне материальную помощь в связи с тем, что #{cause}.", indent_paragraphs: 10
  pdf.move_down 25
  pdf.text 'Приложение:', indent_paragraphs: 10
  pdf.move_down 10
  pdf.text '— копия паспорта (страницы 2-3 и 4-5);'
  support.options.each do |option|
    option.cause.reasons.each do |reason|
      pdf.move_down 10
      pdf.text "— #{reason.pattern}" + ((option == support.options.last && reason == option.cause.reasons.last) ? '.' : ';')
    end
  end
  pdf.move_down 30
  pdf.text "#{l(Date.today, format: '%d.%m.%Y')}                                                                                                                         ___________________ / ___________________"
  pdf.font 'PTSerif', size: 8 do
    pdf.indent 370 do
      pdf.text 'подпись                     расшифровка'
    end
  end
  pdf.move_down 30
  pdf.text 'Резолюция старосты группы:'
  pdf.line_width = 0.7
  pdf.stroke do
    pdf.move_down 10
    pdf.horizontal_rule
  end
  pdf.move_down 10
  pdf.text "«__» _______________ #{Study::Discipline::CURRENT_STUDY_TERM == 1 ? Study::Discipline::CURRENT_STUDY_YEAR : (Study::Discipline::CURRENT_STUDY_YEAR+1)}г.                                                                                                 ___________________ / __________________"
  pdf.move_down 30
  pdf.text 'Резолюция дирекции института:'
  pdf.stroke do
    pdf.move_down 10
    pdf.horizontal_rule
  end
  pdf.move_down 10
  pdf.text "«__» _______________ #{Study::Discipline::CURRENT_STUDY_TERM == 1 ? Study::Discipline::CURRENT_STUDY_YEAR : (Study::Discipline::CURRENT_STUDY_YEAR+1)}г.                                                                                                 ___________________ / __________________"

  pdf.bounding_box [-60, pdf.bounds.bottom + 60], width: pdf.bounds.width + 200 do
     pdf.line_width = 1.8
     pdf.dash (length = 6)
     pdf.stroke do
       pdf.move_down 10
       pdf.horizontal_rule
     end
  end
  pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 50], width: pdf.bounds.width + 15 do
    pdf.move_down 10
    pdf.text "Заявление №#{support.id} на мат. помощь от #{@student.person.short_name(:rp)}, #{@student.group.name} принято «___» ________________ #{Study::Discipline::CURRENT_STUDY_TERM == 1 ? Study::Discipline::CURRENT_STUDY_YEAR : (Study::Discipline::CURRENT_STUDY_YEAR+1)}г."
    pdf.move_down 15
    pdf.text '__________________ / __________________', align: :right
  end
end