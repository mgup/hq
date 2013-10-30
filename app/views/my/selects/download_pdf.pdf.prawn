prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: 'Дисциплины по выбору.pdf',
               page_size: 'A4', page_layout: :portrait do |pdf|
 selects = @student.choices
 pdf.indent 350 do
  pdf.text "Декану #{@student.group.speciality.faculty.abbreviation}"
  pdf.text 'имя декана'
  pdf.text "от студента группы #{@student.group.name}"
  pdf.text "#{@student.person.iname.rp} #{@student.person.oname.rp} #{@student.person.fname.rp}"
 end
 pdf.move_down 70
 pdf.text 'ЗАЯВЛЕНИЕ', align: :center
 pdf.move_down 50
 pdf.text "Прошу вас допустить меня к изучению нижеперечисленных дисциплин по выбору, предусмотренных учебным планом в #{YEAR}/#{YEAR+1} учебном году по направлению #{@student.group.speciality.code} «#{@student.group.speciality.name}».", indent_paragraphs: 10
 pdf.move_down 25
 selected_choices = []
 selects.collect {|c| c.term}.uniq.each do |term|
  selected_choices << selects.where(optional_term: term)
 end
 selected_choices.each do |term|
  pdf.text 'В' + (term.first.term == 1 ? '' : 'о') + " #{term.first.term} семестре:", indent_paragraphs: 10
  term.each do |select|
    pdf.move_down 10
    pdf.text "— #{select.title}" + ((select == term.last && term == selected_choices.last) ? '.' : ';')
  end
 end
 pdf.move_down 50
 pdf.text "#{l(Date.today, format: '%d.%m.%Y')}"
end