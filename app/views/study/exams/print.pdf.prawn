prawn_document margin: [28, 28, 28, 28],
               filename: "Экзаменационная ведомость № #{@exam.id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|

  pdf.font_families.update(
      'PT'=> {
          normal: Rails.root.join('app', 'assets', 'fonts', 'PTS55F_W.ttf').to_s,
          italic: Rails.root.join('app', 'assets', 'fonts', 'PTS56F_W.ttf').to_s,
          bold:   Rails.root.join('app', 'assets', 'fonts', 'PTC75F_W.ttf').to_s})
  pdf.font 'PT', size: 12
  #render 'pdf/header', pdf: pdf, title: "ЭКЗАМЕНАЦИОННАЯ (ЗАЧЁТНАЯ) ВЕДОМОСТЬ № #{@exam.id}"

  pdf.font_size 9 do
    pdf.text_box 'Федеральное государственное бюджетное образовательное учреждение высшего профессионального образования', at: [37, 842 - 28 - 5]
  end
  pdf.text_box '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА»', at: [30, 842 - 28 - 18]
  pdf.line [0, 842 - 56 - 10], [595 - 56, 842 - 56 - 10]
  if @exam.is_repeat?
    pdf.text_box "ДОПОЛНИТЕЛЬНАЯ ЭКЗАМЕНАЦИОННАЯ (ЗАЧЕТНАЯ) ВЕДОМОСТЬ № #{@exam.id}", at: [68, 842 - 70]
  else
     pdf.text_box "ЭКЗАМЕНАЦИОННАЯ (ЗАЧЁТНАЯ) ВЕДОМОСТЬ № #{@exam.id}", at: [120, 842 - 70]
  end

  group = @exam.discipline.group

  pdf.font_size 10 do
    pdf.text_box 'Семестр:', at: [0, 750]
    pdf.text_box 'Форма контроля:', at: [0, 750 - 15]
    pdf.text_box 'Дисциплина:', at: [0, 750 - 30]
    pdf.text_box 'Фамилия, имя, отчество преподавателя(лей):', at: [0, 750 - 45]
    if @exam.is_repeat?
        pdf.text_box 'Дата выдачи:', at: [370, 750]
    else
        pdf.text_box 'Дата проведения:', at: [370, 750]
    end
    pdf.text_box 'Группа:', at: [370, 750 - 15]

    pdf.text_box "#{@exam.discipline.semester}, #{@exam.discipline.year}-#{@exam.discipline.year+1} учебного года", at: [42, 750]
    pdf.text_box "#{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [(@exam.is_repeat? ? 431 : 450), 750]
     if @exam.is_repeat?
        pdf.text_box " #{@exam.repeat_type}", at: [77, 750 - 15]
     else
       pdf.text_box " #{@exam.name}", at: [77, 750 - 15]
     end

    pdf.text_box "#{@discipline.name}", at: [59, 750 - 15 * 2]
    pdf.text_box "#{group.name}", at: [405, 750 - 15]
    pdf.text_box "#{@discipline.lead_teacher.full_name}", at: [199, 750 - 45]
  end


  pdf.font_size 10 do


      y_pos = 625
      x_pos = 26
      size = 10

      pdf.fill_and_stroke_rectangle [0, 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14, 14], 14, 14
      pdf.fill_and_stroke_rectangle [0, 842 - 28 - 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14, 842 - 28 - 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14, 750 - 15 * 3], 14, 14

      pdf.move_down 110

      if @discipline.brs?
        height = 53
        tableData = [[
          pdf.text_box('№', at: [x_pos - 21, y_pos+40], size: size, height: 110),
          pdf.text_box('Фамилия, имя, отчество', at: [x_pos + 3, y_pos+40], size: size, height: 110),
          pdf.text_box('Номер', at: [x_pos + 198, y_pos+40], size: size, height: 110),
          pdf.text_box('Зачтено', at: [x_pos + 240, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Не зачтено', at: [x_pos + 255, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Отлично', at: [x_pos + 270, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Хорошо',at: [x_pos + 285, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Удовл.', at: [x_pos + 300, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Неуд.', at: [x_pos + 315, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Недопущ.', at: [x_pos + 330, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Неявка', at: [x_pos + 345, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Набранный балл за семестр', at: [x_pos + 360, y_pos], rotate: 90, size: size, width: 53),
          pdf.text_box('Результат прописью', at: [x_pos + 401, y_pos+40],  size: size, width: 50, height: 110),
          pdf.text_box('Подпись экзаменатора', at: [x_pos + 450, y_pos+40], size: size, width: 65, height: 110)
        ]]
        position_y = y_pos
        if @exam.is_mass_repeat?
          @exam.students.each_with_index do |student, index|
            position_x = x_pos
            if @exam.test?
              if student.student.ball(@discipline) < 55
                tableData << [index+1, student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', "#{student.student.ball(@discipline)}+", '', '']
              else
                tableData << [index+1, student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', student.student.ball(@discipline), 'зачтено', '']
                pdf.move_to [position_x + 242, position_y - 5.4]
                pdf.line_to [position_x + 249, position_y - 12.4]
                pdf.move_to [position_x + 249, position_y - 5.4]
                pdf.line_to [position_x + 242, position_y - 12.4]
              end
            elsif @exam.exam?
              tableData << [1, student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', '', '', '']
            else
             tableData << [index+1, student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', "#{student.student.ball(@discipline)}+", '', '']
            end
            8.times do
              pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
              position_x += 15
            end
            position_y -= 15
          end
        elsif @exam.is_individual_repeat?
          position_x = x_pos
          if @exam.test?
            if @exam.student.ball(@discipline) < 55
              tableData << [1, @exam.student.person.full_name, @exam.student.id, '', '', '', '', '', '', '', '', "#{@exam.student.ball(@discipline)}+", '', '']
            else
              tableData << [1, @exam.student.person.full_name, @exam.student.id, '', '', '', '', '', '', '', '', @exam.student.ball(@discipline), 'зачтено', '']
              pdf.move_to [position_x + 242, position_y - 5.4]
              pdf.line_to [position_x + 249, position_y - 12.4]
              pdf.move_to [position_x + 249, position_y - 5.4]
              pdf.line_to [position_x + 242, position_y - 12.4]
            end
          elsif @exam.exam?
            tableData << [1, @exam.student.person.full_name, @exam.student.id, '', '', '', '', '', '', '', '', '', '', '']
          else
           tableData << [index+1, @exam.student.person.full_name,  @exam.student.id, '', '', '', '', '', '', '', '', "#{ @exam.student.ball(@discipline)}+", '', '']
          end
          8.times do
            pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
            position_x += 15
          end
        else
          @discipline.group.students.each_with_index do |student, index|
            position_x = x_pos
            if @exam.test?
              if student.ball(@discipline) < 55
                tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', "#{student.ball(@discipline)}+", '', '']
              else
                tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', student.ball(@discipline), 'зачтено', '']
                pdf.move_to [position_x + 242, position_y - 5.4]
                pdf.line_to [position_x + 249, position_y - 12.4]
                pdf.move_to [position_x + 249, position_y - 5.4]
                pdf.line_to [position_x + 242, position_y - 12.4]
              end
            elsif @exam.exam?
              tableData << [1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', '', '', '']
            else
             tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', "#{student.ball(@discipline)}+", '', '']
            end
            8.times do
              pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
              position_x += 15
            end
            position_y -= 15
          end
        end

      else
        height = 35
        tableData = [[{content: '№', rowspan: 2}, {content: 'Фамилия, имя, отчество', rowspan: 2},
                      {content: 'Номер', rowspan: 2}, {content:  pdf.text_box('Зачтено', at: [x_pos + 240, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Не зачтено', at: [x_pos + 255, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Отлично', at: [x_pos + 270, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Хорошо',at: [x_pos + 285, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Удовл.', at: [x_pos + 300, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неуд.', at: [x_pos + 315, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Недопущ.', at: [x_pos + 330, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неявка', at: [x_pos + 345, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: 'Экзамен', colspan: 2}, {content: 'Подпись экзаменатора', rowspan: 2}], ['Цифрой', 'Прописью']]

        position_y = y_pos
        @discipline.group.students.each_with_index do |student, index|
          position_x = x_pos
          tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', '', '', '']
          8.times do
            pdf.rectangle [position_x + 242, position_y - 5], 7, 7
            position_x += 15
          end
          position_y -= 15
        end
      end

      pdf.font_size 10 do
        pdf.table tableData, header: true, cell_style: { padding: [0, 0, 2, 2] } do
         row(0).height = height
         column(0).width = 24
         column(1).width = 194.28 #157
         column(2).width = 46 #35
         8.times.each do |i|
           column(i+3).width = 15
         end
         column(11).width = 40
         column(12).width = 50 #60
         column(13).width = 65 #80
        end
      end

      pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 60], width: pdf.bounds.width do
        if @exam.is_repeat?
           pdf.move_down 15
           pdf.indent (@exam.repeat == Study::Exam::COMMISSION_REPEAT ? 32 : 28)  do
            pdf.text "Дата сдачи: ______________________                                                          Ведомость действительна до #{@exam.date.sunday? ? (l @exam.date.next) : (@exam.date.saturday? ? (l @exam.date.next_day(2)) : (l @exam.date))}"
           end
           pdf.move_down 18
        else
          footData = [['Явилось', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Зачтено', 'Не зачтено', 'Недопущ.', 'Неявка', 'Ср. балл'],
                      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
          pdf.table footData, width: pdf.bounds.width,
                          cell_style: { padding: 2}
          pdf.move_down 12
        end
        pdf.text "#{@exam.repeat == Study::Exam::COMMISSION_REPEAT ? 'Подписи членов комиссии' : 'Подпись преподавателя(лей)'} _____________________________           Директор института _____________________________", align: :center
      end
  end
  if @discipline.brs?
    if @exam.exam?
      pdf.start_new_page
    else
      pdf.start_new_page layout: :landscape
    end

    pdf.font_size 9 do
      pdf.text 'Федеральное государственное бюджетное образовательное учреждение высшего профессионального образования', align: :center
    end
    pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center
    pdf.move_down 10
    pdf.text "ПРИЛОЖЕНИЕ К ЭКЗАМЕНАЦИОННОЙ ВЕДОМОСТИ № #{@exam.id}", align: :center
    if @exam.exam?
      pdf.font_size 10 do
        pdf.text_box 'Семестр:', at: [0, 750 - 25]
        pdf.text_box 'Форма контроля:', at: [0, 750 - 40]
        pdf.text_box 'Дисциплина:', at: [0, 750 - 55]
        pdf.text_box 'Фамилия, имя, отчество преподавателя(лей):', at: [0, 750 - 70]
        if @exam.is_repeat?
            pdf.text_box 'Дата выдачи:', at: [370, 750 - 25]
        else
            pdf.text_box 'Дата проведения:', at: [370, 750 - 25]
        end
        pdf.text_box 'Группа:', at: [370, 750 - 40]

        pdf.text_box "#{@exam.discipline.semester}, #{@exam.discipline.year}-#{@exam.discipline.year+1} учебного года", at: [42, 750 - 25]
        pdf.text_box "#{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [(@exam.is_repeat? ? 431 : 450), 750 - 25]
         if @exam.is_repeat?
            pdf.text_box " #{@exam.repeat_type}", at: [77, 750 - 40]
         else
           pdf.text_box " #{@exam.name}", at: [77, 750 - 40]
         end

        pdf.text_box "#{@discipline.name}", at: [59, 750 - 55]
        pdf.text_box "#{group.name}", at: [405, 750 - 40]
        pdf.text_box "#{@discipline.lead_teacher.full_name}", at: [199, 750 - 70]
      end

      applicationTable = [[{content: '№', rowspan: 2}, {content: 'Фамилия, имя, отчество', rowspan: 2},
                          {content: 'Номер', rowspan: 2}, {content: 'Баллы за семестр', rowspan: 2}, {content: 'Нужно набрать на экзамене в баллах', colspan: 4}],
                          ['«Отлично»', '«Хорошо»', '«Удовл.»', '«Неуд.»']]
      pdf.font_size 10 do
        if @exam.is_mass_repeat?
          @exam.students.each_with_index do |student, index|
            result_5 = @discipline.final_exam.predication(5, student.student.ball(@discipline))
            result_4 = @discipline.final_exam.predication(4, student.student.ball(@discipline))
            result_3 = @discipline.final_exam.predication(3, student.student.ball(@discipline))
            result_2 = @discipline.final_exam.predication(2, student.student.ball(@discipline))
            applicationTable << [index+1, student.person.full_name, student.student.id, student.student.ball(@discipline), "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
          end
        elsif @exam.is_individual_repeat?
          result_5 = @discipline.final_exam.predication(5, @exam.student.ball(@discipline))
          result_4 = @discipline.final_exam.predication(4, @exam.student.ball(@discipline))
          result_3 = @discipline.final_exam.predication(3, @exam.student.ball(@discipline))
          result_2 = @discipline.final_exam.predication(2, @exam.student.ball(@discipline))
          applicationTable << [1, @exam.student.person.full_name, @exam.student.id, @exam.student.ball(@discipline), "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
        else
          @discipline.group.students.each_with_index do |student, index|
            result_5 = @discipline.final_exam.predication(5, student.ball(@discipline))
            result_4 = @discipline.final_exam.predication(4, student.ball(@discipline))
            result_3 = @discipline.final_exam.predication(3, student.ball(@discipline))
            result_2 = @discipline.final_exam.predication(2, student.ball(@discipline))
            applicationTable << [index+1, student.person.full_name, student.id, student.ball(@discipline), "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
          end
        end
        pdf.move_down 80
        pdf.table applicationTable, width: pdf.bounds.width, cell_style: { padding: 2}
      end

    else
      pdf.font_size 10 do
        pdf.text_box 'Семестр:', at: [0, 500 - 25]
        pdf.text_box 'Форма контроля:', at: [0, 500 - 40]
        pdf.text_box 'Дисциплина:', at: [0, 500 - 55]
        pdf.text_box 'Фамилия, имя, отчество преподавателя(лей):', at: [0, 500 - 70]
        if @exam.is_repeat?
            pdf.text_box 'Дата выдачи:', at: [570, 500 - 25]
        else
            pdf.text_box 'Дата проведения:', at: [570, 500 - 25]
        end
        pdf.text_box 'Группа:', at: [570, 500 - 40]

        pdf.text_box "#{@exam.discipline.semester}, #{@exam.discipline.year}-#{@exam.discipline.year+1} учебного года", at: [42, 500 - 25]
        pdf.text_box "#{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [(@exam.is_repeat? ? 631 : 650), 500 - 25]
         if @exam.is_repeat?
            pdf.text_box " #{@exam.repeat_type}", at: [77, 500 - 40]
         else
           pdf.text_box " #{@exam.name}", at: [77, 500 - 40]
         end

        pdf.text_box "#{@discipline.name}", at: [59, 500 - 55]
        pdf.text_box "#{group.name}", at: [605, 500 - 40]
        pdf.text_box "#{@discipline.lead_teacher.full_name}", at: [199, 500 - 70]
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
        if @exam.is_mass_repeat?
          index = 1
          @exam.students.each do |student|
            if (!(student.student.ball(@discipline) < 55) && @exam.test?)
              next
            end
            applicationTable << [index, student.person.full_name, student.student.id, student.student.ball(@discipline)]
            @discipline.checkpoints.each do |checkpoint|
              applicationTable[applicationTable.length - 1] << "#{checkpoint.min}/#{checkpoint.max}"
              applicationTable[applicationTable.length - 1] << "#{checkpoint.marks.by_student(student.student).last ? checkpoint.marks.by_student(student).last.mark : 0}"
              applicationTable[applicationTable.length - 1] << ''
            end
            index+=1
          end
        elsif @exam.is_individual_repeat?
          applicationTable << [1, @exam.student.person.full_name, @exam.student.id, @exam.student.ball(@discipline)]
          @discipline.checkpoints.each do |checkpoint|
            applicationTable[applicationTable.length - 1] << "#{checkpoint.min}/#{checkpoint.max}"
            applicationTable[applicationTable.length - 1] << "#{checkpoint.marks.by_student(@exam.student).last ? checkpoint.marks.by_student(student).last.mark : 0}"
            applicationTable[applicationTable.length - 1] << ''
          end
        else
          index = 1
          @discipline.group.students.each do |student|
            if (!(student.ball(@discipline) < 55) && @exam.test?)
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
        end
        pdf.move_down 80
        pdf.table applicationTable, width: pdf.bounds.width, cell_style: { padding: 2} do
          column(3).width = 50
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