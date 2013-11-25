prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Экзаменационная ведомость № #{@exam.id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/header', pdf: pdf, title: "ЭКЗАМЕНАЦИОННАЯ (ЗАЧЁТНАЯ) ВЕДОМОСТЬ № #{@exam.id}"
  group = @exam.discipline.group
  teachers = []
  teachers << @discipline.lead_teacher.full_name
  teachers << @discipline.assistant_teachers.collect{|t| t.full_name} if @discipline.assistant_teachers != []
  headData = [["Семестр: #{Study::Discipline::CURRENT_STUDY_TERM}, #{Study::Discipline::CURRENT_STUDY_YEAR}-#{Study::Discipline::CURRENT_STUDY_YEAR+1} учебного года", "Дата проведения: #{@exam.date ? @exam.date : 'неизвестно'}" ],
              ["Форма контроля: #{@exam.name}", "Группа: #{group.name}"],
              ["Дисциплина: #{@discipline.name}", ''],
              ["Фамилия, имя, отчество преподавател#{teachers.length > 1 ? 'ей' : 'я'}: #{teachers.join(', ')}", '']]
  pdf.font_size 9 do
      pdf.table headData, header: true, width: pdf.bounds.width,
                cell_style: { padding: 2, border_color: "ffffff" }

      y_pos = 563
      x_pos = 2
      size = 8
      if @discipline.brs?
        height = 50
        tableData = [[
          pdf.text_box('№', at: [x_pos, y_pos+30], size: size, height: 100),
          pdf.text_box('Фамилия, имя, отчетсво', at: [x_pos + 20, y_pos+30], size: size, height: 100),
          pdf.text_box('Номер', at: [x_pos + 172, y_pos+30], size: size, height: 100),
          pdf.text_box('Зачтено', at: [x_pos + 205, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Не зачтено', at: [x_pos + 220, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Отлично', at: [x_pos + 235, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Хорошо',at: [x_pos + 250, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Удовл.', at: [x_pos + 265, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Неуд.', at: [x_pos + 280, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Недопущ.', at: [x_pos + 295, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Неявка', at: [x_pos + 310, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Балл, набранный за семестр', at: [x_pos + 325, y_pos], rotate: 90, size: size, width: 50),
          pdf.text_box('Результат прописью', at: [x_pos + 365, y_pos+30],  size: size, width: 50, height: 100),
          pdf.text_box('Подпись экзаменатора', at: [x_pos + 425, y_pos+30], size: size, width: 60, height: 100)
        ]]
        @discipline.group.students.each_with_index do |student, index|
          tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', student.ball(@discipline).round, '', '']
        end
      else
        height = 35
        tableData = [[{content: '№', rowspan: 2}, {content: 'Фамилия, имя, отчетсво', rowspan: 2},
                      {content: 'Номер', rowspan: 2}, {content:  pdf.text_box('Зачтено', at: [x_pos + 205, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Не зачтено', at: [x_pos + 220, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Отлично', at: [x_pos + 235, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Хорошо',at: [x_pos + 250, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Удовл.', at: [x_pos + 265, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неуд.', at: [x_pos + 280, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Недопущ.', at: [x_pos + 295, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неявка', at: [x_pos + 310, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: 'Экзамен', colspan: 2}, {content: 'Подпись экзаменатора', rowspan: 2}], ['Цифрой', 'Прописью']]

        @discipline.group.students.each_with_index do |student, index|
          tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', '', '', '']
        end
      end

      pdf.move_down 7
      pdf.font_size 8 do
        pdf.table tableData, header: true, cell_style: { padding: 1.8 } do
         row(0).height = height
         column(1).width = 157
         column(2).width = 35
         8.times.each do |i|
           column(i+3).width = 15
         end
         column(11).width = 40
         column(12).width = 60
         column(13).width = 80
        end
      end

      pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 60], width: pdf.bounds.width do
        footData = [['Явилось', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Зачтено', 'Не зачтено', 'Недопущ.', 'Неявка', 'Ср. балл'],
                    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
        pdf.table footData, width: pdf.bounds.width,
                        cell_style: { padding: 2}
        pdf.move_down 10
        pdf.text "Подпись преподавател#{teachers.length > 1 ? 'ей' : 'я'} ________________________           Директор института ________________________", align: :center
        end
  end
end