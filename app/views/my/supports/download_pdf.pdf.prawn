prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: 'Заявление на материальную помощь.pdf',
               page_size: 'A4', page_layout: :portrait do |pdf|
 render 'pdf/font', pdf: pdf
 support = @student.supports.last
   pdf.font_size = 9
   pdf.indent 350 do
    pdf.text 'Ректору федерального государственного'
    pdf.text 'бюджетного учреждения высшего'
    pdf.text 'профессионального образования'
    pdf.text '«Московский государственный университет'
    pdf.text 'печати имени Ивана Федорова»'
    pdf.text 'К. В. Антипову'
    pdf.text "от студента #{@student.group.course} курса #{@student.group.support} формы обучения"
    pdf.text "#{@student.group.speciality.faculty.abbreviation}, группы #{@student.group.name}"
    pdf.text "#{@student.person.full_name(:rp)} , #{support.birthday}"
    pdf.text "паспорт #{support.series} #{support.number} выдан #{support.date} #{support.department},"
    pdf.text "адрес регистрации: #{support.address}, #{support.phone}"
  end
  pdf.move_down 25
  pdf.text 'ЗАЯВЛЕНИЕ', align: :center
  pdf.move_down 10
  pdf.text 'о выплате материальной помощи', align: :center
  pdf.move_down 25
  cause = ''
  support.support_options.each do |option|
    cause << (@student.person.male? ? option.cause.pattern : (option.cause.patternf == nil ? option.cause.pattern : option.cause.patternf))
    cause << ', '
  end
  cause = cause[0..-3]
  pdf.text "Прошу Вас предоставить мне материальную помощь в связи с тем, что #{cause}.", indent_paragraphs: 10
  pdf.move_down 25
  pdf.text 'Приложение:', indent_paragraphs: 10
  pdf.move_down 10
  pdf.text '— копия паспорта (страницы 2-3 и 4-5);'
  support.support_options.each do |option|
    option.cause.reasons.each do |reason|
      pdf.move_down 10
      pdf.text "— #{reason.pattern}" + ((option == support.support_options.last && reason == option.cause.reasons.last) ? '.' : ';')
    end
  end
  pdf.move_down 30
  pdf.text "#{l(Date.today, format: '%d.%m.%Y')}                                                                                                                                                ___________________ / #{@student.person.iname.ip[0]}. #{@student.person.oname.ip[0]}. #{@student.person.fname.ip}"
  pdf.move_down 30
  pdf.text 'Резолюция старосты группы:'
  pdf.line_width = 0.7
  pdf.stroke do
    pdf.move_down 10
    pdf.horizontal_rule
  end
  pdf.move_down 10
  pdf.text "«__» _______________ #{Study::Discipline::CURRENT_STUDY_YEAR}г.                                                                                                                       ___________________ / __________________"
  pdf.move_down 30
  pdf.text 'Резолюция деканата:'
  pdf.stroke do
    pdf.move_down 10
    pdf.horizontal_rule
  end
  pdf.move_down 10
  pdf.text "«__» _______________ #{Study::Discipline::CURRENT_STUDY_YEAR}г.                                                                                                                       ___________________ / __________________"

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
    pdf.text "Заявление на мат. помощь от #{@student.person.short_name(:rp)}, #{@student.group.name} принято «___» ________________ #{Study::Discipline::CURRENT_STUDY_YEAR}г."
    pdf.move_down 15
    pdf.text '__________________ / __________________', align: :right
  end
end