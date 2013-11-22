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
      if @discipline.brs?
        tableData = [['№', 'Фамилия, имя, отчетсво', 'Номер', 'Зачтено', 'Не зачтено', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Недопущ.', 'Неявка', 'Балл, набранный за семестр', 'Результат прописью', 'Подпись экзаменатора']]
        @discipline.group.students.each_with_index do |student, index|
          tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', student.ball(@discipline), '', '']
        end
      else
        tableData = [['№', 'Фамилия, имя, отчетсво', 'Номер', 'Зачтено', 'Не зачтено', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Недопущ.', 'Неявка', 'Экзамен цифрой', 'Экзамен прописью', 'Подпись экзаменатора']]
        @discipline.group.students.each_with_index do |student, index|
          tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', '', '', '']
        end
      end

      pdf.font_size 7 do
        pdf.table tableData, header: true do
         row(0).height = 100
         8.times.each do |i|
          column(i+3).style( rotate: 90 )
         end
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