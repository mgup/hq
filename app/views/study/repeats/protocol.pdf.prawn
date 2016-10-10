prawn_document margin: [40, 54, 28, 54],
               filename: "Ведомость № #{@exam.id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|

  pdf.font_families.update(
    'PT'=> {
      normal: Rails.root.join('app', 'assets', 'fonts', 'PT Serif.ttf').to_s,
      italic: Rails.root.join('app', 'assets', 'fonts', 'PTS56F_W.ttf').to_s,
      bold:   Rails.root.join('app', 'assets', 'fonts', 'PT Serif Bold.ttf').to_s})
  pdf.font 'PT', size: 12

  pdf.font_size 11 do
    pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
    pdf.text 'ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ', align: :center
    pdf.text 'ВЫСШЕГО ОБРАЗОВАНИЯ', align: :center
    pdf.text '«МОСКОВСКИЙ ПОЛИТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ»', style: :bold, align: :center
    pdf.text '(МОСКОВСКИЙ ПОЛИТЕХ)', style: :bold, align: :center
    # pdf.text 'Высшая школа печати и медиаиндустрии', style: :bold, align: :center
  end

  pdf.move_down 25

  pdf.text 'Институт _______________________________________________________________________________________'
  pdf.move_down 5
  pdf.text 'Кафедра ________________________________________________________________________________________'

  pdf.font_size 11 do
    pdf.text_box @repeat.exam.discipline.group.speciality.faculty.name, at: [100, 678], width: 350, align: :center
    if @repeat.department
     pdf.text_box @repeat.department.name, at: [58, 657], width: 410, align: :center
    end
  end

  pdf.move_down 7
  pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ КОМИССИИ', style: :bold, align: :center
  pdf.text 'ПО ПРОВЕДЕНИЮ ПРОМЕЖУТОЧНОЙ АТТЕСТАЦИИ', style: :bold, align: :center
  pdf.move_down 10

  pdf.text 'По дисциплине (практике): ___________________________________________________________________'
  pdf.move_down 1
  pdf.text '___________________________________________________________________________________________________'

  pdf.font_size 11 do
    pdf.text_box "                                                             #{@repeat.exam.discipline.name}", at: [0, 593], width: 500, height: 50, leading: 1
  end
  pdf.move_down 8
  pdf.text 'Учебный год: _________________          Семестр: _________________         Группа: _________________'

  pdf.font_size 11 do
    pdf.text_box "#{@exam.discipline.year}/#{@exam.discipline.year+1}", at: [95, 554]
    pdf.text_box "#{@exam.discipline.semester == 1 ? @exam.discipline.group.group_semester : @exam.discipline.group.group_semester+1}", at: [280, 554]
    pdf.text_box @exam.discipline.group.name, at: [413, 554]
  end

  pdf.move_down 8
  pdf.text 'Форма контроля: ______________________________________________________________________________'
  pdf.font_size 7 do
    pdf.indent 202 do
      pdf.text 'экзамен, зачет, дифференцированный зачет, защита'
    end
  end
  pdf.font_size 11 do
    pdf.text_box @repeat.rname, width: 320, height: 20, align: :center, at: [103, 530]
  end
  pdf.move_down 5

  pdf.text 'Председатель комиссии: ______________________________________________________________________'
  pdf.font_size 11 do
    if @repeat.commission_head
      pdf.text_box @repeat.commission_head.science + ' ' + @repeat.commission_head.user.full_name, width: 320, height: 20, align: :center, at: [103, 500]
    end
  end
  pdf.move_down 5
  pdf.text 'Члены комиссии: ______________________________________________________________________________'

  pdf.font_size 11 do
    if @repeat.commission_teachers.any?
      pdf.text_box @repeat.commission_teachers.collect{|t| t.science + ' ' + t.user.short_name}.join(', '), width: 320, height: 20, align: :center, at: [103, 480]
    end
  end
  pdf.move_down 5
  pdf.text 'Дата проведения аттестации: «____» ___________________________ 20_____ г.'

  pdf.font_size 11 do
    pdf.text_box "#{l @repeat.date, format: '%d'}", at: [169, 459], width: 30, height: 20, align: :center
    pdf.text_box "#{l @repeat.date, format: '%B'}", at: [215, 459], width: 100, height: 20, align: :center
    pdf.text_box "#{l @repeat.date, format: '%y'}", at: [348, 459], width: 30, height: 20, align: :center
  end

  if @exam.discipline.brs? && @exam.result_exam?
    tableData = [['№', 'ФИО студента', '№ зачетной книжки', '№ билета', 'Балл семестра', 'Балл аттестации', 'Оценка прописью', 'Подпись председателя комиссии']]
    @repeat.students.each_with_index do |student, index|
      tableData << [index+1,  student.person.full_name, student.id, '',
                    (@exam.test? || @exam.graded_test?) ? "#{student.ball(@discipline)}+" : '', '', '', '']
    end

    pdf.move_down 10
    pdf.font_size 9 do
      pdf.table tableData, header: true, cell_style: { padding: [1, 1, 2, 2], align: :center, valign: :center} do
        column(0).width = 16
        column(1).width = 145.28
        column(2).width = 54
        column(3).width = 50
        column(4).width = 47
        column(5).width = 53
        column(6).width = 56
        column(7).width = 66
        row(0).font_style = :bold
        style(column(1), align: :left, valign: :center)
        style(row(0).columns(0..-1), align: :center, valign: :center, size: 8)
      end
    end
  else
    tableData = [['№', 'ФИО студента', '№ зачетной книжки', 'Оценка прописью', 'Подпись председателя комиссии']]
    @repeat.students.each_with_index do |student, index|
      tableData << [index+1,  student.person.full_name, student.id, '', '']
    end

    pdf.move_down 10
    pdf.font_size 9 do
      pdf.table tableData, header: true, cell_style: { padding: [1, 1, 2, 2], align: :center, valign: :center} do
        row(0).font_style = :bold
        row(0).height = 30
        column(1).width = 200
        style(column(1), align: :left, valign: :center)
        style(row(0).columns(0..-1), align: :center, valign: :center, size: 8)
      end
    end
  end


  pdf.indent 142 do
    pdf.move_down 10
    pdf.text 'Председатель комиссии: ___________________ (____________________)'
    pdf.font_size 7 do
      pdf.indent 165 do
        pdf.text '(подпись)                                         (расшифровка)'
      end
    end
    pdf.move_down 5
    pdf.indent 40 do
      pdf.text 'Члены комиссии: ___________________ (____________________)'
    end
    pdf.indent 141 do
      pdf.move_down 2
      pdf.text '___________________ (____________________)'
      pdf.move_down 2
      pdf.text '___________________ (____________________)'
    end
    pdf.move_down 10
    pdf.indent 18 do
      pdf.text 'Директор Института: ___________________ (____________________)'
    end
    pdf.move_down 5
    pdf.indent 12 do
      pdf.text 'Сотрудник Института: ___________________ (____________________)'
      pdf.font_size 7 do
        pdf.indent 165 do
          pdf.text '(подпись лица, выдавшего протокол)'
        end
      end
    end
  end

  pdf.font_size 11 do
    pdf.text_box 'Протокол закрыт и сдан: ___________________ (____________________)', at: [0, 60]
  end
  pdf.font_size 7 do
    pdf.text_box '(сотрудник дирекции, принявший протокол)', at: [152, 45]

  end
  pdf.font_size 11 do
    pdf.text_box '«____» ___________________________ 20_____ г.', at: [0, 30]
  end


  if @discipline.brs? && (Study::Exam.finals.include? @exam)
    if @exam.exam?
      pdf.start_new_page
    else
      pdf.start_new_page layout: :landscape #если зачёты, альбомная ориентация
    end

    pdf.font_size 10 do
      pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
      pdf.text 'ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ', align: :center
      pdf.text '«МОСКОВСКИЙ ПОЛИТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ» (МОСКОВСКИЙ ПОЛИТЕХ)', style: :bold, align: :center

      pdf.move_down 5
      pdf.text 'ПРИЛОЖЕНИЕ К ПРОТОКОЛУ', align: :center
    end
    if @exam.exam?
      pdf.font_size 10 do
        pdf.text_box 'Семестр:', at: [0, 720 - 25]
        pdf.text_box 'Форма контроля:', at: [0, 720 - 40]
        pdf.text_box 'Дисциплина:', at: [0, 720 - 55]
        pdf.text_box 'Дата выдачи:', at: [370, 720 - 25]
        pdf.text_box 'Группа:', at: [370, 720 - 40]

        pdf.text_box "#{@exam.discipline.semester}, #{@exam.discipline.year}-#{@exam.discipline.year+1} учебного года", at: [46, 720 - 25]
        pdf.text_box "#{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [435, 720 - 25]
        pdf.text_box "#{@exam.name}, #{@repeat.repeat_type}", at: [86, 720 - 40]

        pdf.text_box "#{@discipline.name}", at: [66, 720 - 55]
        pdf.text_box "#{@discipline.group.name}", at: [409, 720 - 40]

        # pdf.text_box "Фамилия Имя Отчество", at: [199, 750 - 70]
      end

      applicationTable = [[{content: '№', rowspan: 2}, {content: 'Фамилия, имя, отчество', rowspan: 2},
                           {content: 'Номер', rowspan: 2}, {content: 'Баллы за семестр', rowspan: 2}, {content: 'Нужно набрать на экзамене в баллах', colspan: 4}],
                          ['«Отлично»', '«Хорошо»', '«Удовл.»', '«Неуд.»']]
      pdf.font_size 10 do
        @repeat.students.each_with_index do |student, index|
          if student.ball(@discipline) < 55 || !student.pass_discipline?(@discipline)
            applicationTable << [index+1, student.person.full_name, student.id, student.ball(@discipline), '—', '—', '—', '0 — 100']
          else
            result_5 = @discipline.final_exam.predication(5, student.ball(@discipline))
            result_4 = @discipline.final_exam.predication(4, student.ball(@discipline))
            result_3 = @discipline.final_exam.predication(3, student.ball(@discipline))
            result_2 = @discipline.final_exam.predication(2, student.ball(@discipline))
            applicationTable << [index+1, student.person.full_name, student.id, student.ball(@discipline), "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
          end
        end

        pdf.move_down 80
        pdf.table applicationTable, width: pdf.bounds.width, cell_style: { padding: [2, 2, 2, 2], align: :center, valign: :center} do
          column(3).width = 50
          style(column(1), align: :left, valign: :center)
          style(row(0).columns(0..-1), align: :center, valign: :center)
        end
      end
    else
      pdf.font_size 10 do
        pdf.text_box 'Семестр:', at: [0, 490 - 25]
        pdf.text_box 'Форма контроля:', at: [0, 490 - 40]
        pdf.text_box 'Дисциплина:', at: [0, 490 - 55]
        pdf.text_box 'Дата выдачи:', at: [570, 490 - 25]
        pdf.text_box 'Группа:', at: [570, 490 - 40]

        pdf.text_box "#{@exam.discipline.semester}, #{@exam.discipline.year}-#{@exam.discipline.year+1} учебного года", at: [46, 490 - 25]
        pdf.text_box "#{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [636, 490 - 25]
        pdf.text_box "#{@exam.name}, #{@repeat.repeat_type}", at: [83, 490 - 40]
        pdf.text_box "#{@discipline.name}", at: [66, 490 - 55]
        pdf.text_box "#{@discipline.group.name}", at: [610, 490 - 40]
       end

      applicationTable = [[{content: '№', rowspan: 2}, {content: 'Фамилия, имя, отчество', rowspan: 2},
                           {content: 'Номер', rowspan: 2}, {content: 'Аудиторн. баллы', rowspan: 2}], []]
      @discipline.checkpoints.length.times do |i|
        applicationTable[0] << {content: "К. т. #{i+1}", colspan: 3, align: :center}
        applicationTable[1] << {content: 'Всего'}
        applicationTable[1] << {content: 'Есть'}
        applicationTable[1] << {content: 'Досдал'}

      end
      pdf.font_size 10 do
        index = 1
        @repeat.students.each do |student|
          if (!(student.ball(@discipline) < 55) && @exam.test? && student.pass_discipline?(@discipline))
            next
          end
          applicationTable << [index, student.person.full_name, student.id, student.ball(@discipline)]
          @discipline.checkpoints.each do |checkpoint|
            applicationTable[applicationTable.length - 1] << "#{checkpoint.min}/#{checkpoint.max}"
            applicationTable[applicationTable.length - 1] << "#{checkpoint.marks.by_student(student).last ? checkpoint.marks.by_student(student).last.mark : 0}"
            applicationTable[applicationTable.length - 1] << ''
          end
          index+=1
        end

        pdf.move_down 80
        if @discipline.checkpoints.length > 5
          if @discipline.checkpoints.length > 10
            pdf.font_size 6 do
              pdf.table applicationTable, width: pdf.bounds.width, cell_style: { padding: 2}
            end
          else
            pdf.font_size 9 do
              pdf.table applicationTable, width: pdf.bounds.width, cell_style: { padding: 2}
            end
          end
        else
          pdf.table applicationTable, width: pdf.bounds.width, cell_style: { padding: 2}
        end

        if @exam.graded_test?
          pdf.move_down 20
          pdf.text 'Перевод баллов (Х) в итоговую оценку:'
          pdf.table [['неудовлетворительно', 'удовлетворительно', 'хорошо', 'отлично'],['Х < 55', '55 >= X < 70', '70 >= X < 85', 'X >= 85']], width: pdf.bounds.width, cell_style: { padding: 2}
        end
      end
    end
  end

end
