prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|
 support = @student.supports.last

   pdf.indent 350 do
    pdf.text 'Ректору федерального государственного'
    pdf.text 'бюджетного учреждения высшего'
    pdf.text 'профессионального образования'
    pdf.text '«Московский государственный университет'
    pdf.text 'печати имени Ивана Федорова»'
    pdf.text 'К. В. Антипову'
    pdf.text "от студента #{@student.group.course} курса #{@student.group.support} формы обучения"
    pdf.text "#{@student.group.speciality.faculty.abbreviation}, группы #{@student.group.name}"
    pdf.text "#{@student.person.iname.rp} #{@student.person.oname.rp} #{@student.person.fname.rp} , #{support.birthday}"
    pdf.text "паспорт #{support.series} #{support.number} выдан #{support.date} #{support.department},"
    pdf.text "адрес регистрации: #{support.address}, #{support.phone}"
  end
  pdf.move_down 25
  pdf.text 'ЗАЯВЛЕНИЕ', align: :center
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
  pdf.text "#{DateTime.now.strftime("%d.%m.%Y")}                                                                                                                                                             ___________________ / #{@student.person.iname.ip[0]}. #{@student.person.oname.ip[0]}. #{@student.person.fname.ip}"
  pdf.move_down 40
  pdf.text 'Резолюция старосты группы:'
  pdf.move_down 15
  pdf.text '__________________________________________________________________________________________________________________________________________________'
  pdf.move_down 15
  pdf.text "«__» _______________ #{Study::Discipline::CURRENT_STUDY_YEAR}г.                                                                                                                                  ___________________ / __________________"
  pdf.move_down 40
  pdf.text 'Резолюция деканата:'
  pdf.move_down 15
  pdf.text '__________________________________________________________________________________________________________________________________________________'
  pdf.move_down 15
  pdf.text "«__» _______________ #{Study::Discipline::CURRENT_STUDY_YEAR}г.                                                                                                                                  ___________________ / __________________"

  pdf.bounding_box [-50, bounds.bottom + 60], width: bounds.width + 200 do
     pdf.text '— — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — — —'
  end
  pdf.bounding_box [bounds.left, bounds.bottom + 50], width: bounds.width + 15 do
    pdf.move_down 5
    pdf.text "Заявление на мат. помощь от #{@student.person.iname.rp[0]}. #{@student.person.oname.rp[0]}. #{@student.person.fname.rp}, #{@student.group.name} принято «___» ________________ 2013 г."
    pdf.move_down 15
    pdf.text '__________________ / __________________', align: :right
  end
end