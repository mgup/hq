prawn_document margin: [28, 20, 28, 28],
               filename: "Ведомость № #{@exam.id}.pdf",
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
  elsif @exam.validation?
    pdf.text_box 'ВЕДОМОСТЬ КОНТРОЛЯ УСПЕВАЕМОСТИ', at: [160, 842 - 70]
  else
    pdf.text_box "ЭКЗАМЕНАЦИОННАЯ (ЗАЧЁТНАЯ) ВЕДОМОСТЬ № #{@exam.id}", at: [120, 842 - 70]
    # pdf.text_box "ЭКЗАМЕНАЦИОННАЯ (ЗАЧЁТНАЯ) ВЕДОМОСТЬ № XXXX", at: [120, 842 - 70]
  end

  group = @exam.discipline.group

  pdf.font_size 10 do
    pdf.text_box "Учебный год: #{@exam.discipline.year}/#{@exam.discipline.year+1}", at: [0, 750]
    if @exam.is_repeat?
      pdf.text_box "Форма контроля: #{@exam.name}, #{@exam.repeat_type}", at: [0, 750 - 15]
    else
      pdf.text_box "Форма контроля: #{@exam.name}", at: [0, 750 - 15]
    end
    pdf.text_box "Дисциплина: #{@discipline.name}", at: [0, 750 - 30], width: 365
    # pdf.text_box "Дисциплина: Название дисциплины", at: [0, 750 - 30]
    pdf.text_box "Фамилия, имя, отчество преподавателя(лей): #{@discipline.lead_teacher ? @discipline.lead_teacher.full_name : ''}", at: [0, 750 - 58]
    # pdf.text_box "Фамилия, имя, отчество преподавателя(лей): Фамилия Имя Отчество", at: [0, 750 - 45]
    pdf.text_box "Семестр: #{@exam.discipline.semester == 1 ? 'I' : 'II'}", at: [370, 750]
    if @exam.is_repeat?
      pdf.text_box "Дата выдачи: #{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [370, 750 - 15]
    elsif @exam.validation?
      pdf.text_box "Контрольная дата: #{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [370, 750 - 15]
    else
      pdf.text_box "Дата проведения: #{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [370, 750 - 15]
      # pdf.text_box "Дата проведения: #{l Date.today }", at: [370, 750 - 15]
    end
    pdf.text_box "Группа: #{group.name}", at: [370, 750 - 30]
    # pdf.text_box "Группа: Буквенно-цифровой шифр группы", at: [370, 750 - 30]
  end


  pdf.font_size 10 do

      y_pos = 615 + 10
      x_pos = 0 + 26
      size = 10

      pdf.fill_and_stroke_rectangle [0, 14 + 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14 + 4, 14 + 14], 14, 14
      pdf.fill_and_stroke_rectangle [0, 842 - 28 - 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14 + 4, 842 - 28 - 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14 + 4, 750 - 15 * 3], 14, 14

      pdf.move_down 110

      # Для дисциплин, создаваемых преподавателями (БРС)
      if @discipline.brs? && (@exam.graded_test? || @exam.test? || @exam.exam? || @exam.validation?)
        height = 53
        tableData = [['№', 'Фамилия, имя, отчество', 'Номер',
          pdf.text_box('Зачтено', at: [x_pos + 240, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Не зачтено', at: [x_pos + 255, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Отлично', at: [x_pos + 270, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Хорошо',at: [x_pos + 285, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Удовл.', at: [x_pos + 300, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Неуд.', at: [x_pos + 315, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Недопущ.', at: [x_pos + 330, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Неявка', at: [x_pos + 345, y_pos], rotate: 90, size: size, width: 110),
          pdf.text_box('Набранный балл', at: [x_pos + 360, y_pos], rotate: 90, size: size, width: 53),
          'Результат прописью', 'Подпись экзаменатора'
        ]]
        position_y = y_pos
        if @exam.is_mass_repeat? || @exam.is_individual_repeat? #групповая пересдача
          @exam.students.each_with_index do |student, index|
            position_x = x_pos
            if @exam.test? #зачёт
              if student.student.ball(@discipline) < 55 || !student.student.pass_discipline?(@discipline)
                tableData << [index+1, student.student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', "#{student.student.ball(@discipline)}+", '', '']
              else
                tableData << [index+1, student.student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', student.student.ball(@discipline), 'зачтено', '']
                pdf.move_to [position_x + 242, position_y - 5.4]
                pdf.line_to [position_x + 249, position_y - 12.4]
                pdf.move_to [position_x + 249, position_y - 5.4]
                pdf.line_to [position_x + 242, position_y - 12.4]
              end
            elsif @exam.exam? #экзамен
              tableData << [index+1, student.student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', '', '', '']
            else #дифференцированный зачёт
              if student.student.ball(@discipline) < 85 || !student.student.pass_discipline?(@discipline)
                tableData << [index+1, student.student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', "#{student.student.ball(@discipline)}+", '', '']
              else
                tableData << [index+1, student.student.person.full_name, student.student.id, '', '', '', '', '', '', '', '', student.student.ball(@discipline), 'отлично', '']
                pdf.move_to [position_x + 272, position_y - 5.4]
                pdf.line_to [position_x + 279, position_y - 12.4]
                pdf.move_to [position_x + 279, position_y - 5.4]
                pdf.line_to [position_x + 272, position_y - 12.4]
              end
            end
            8.times do
              pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
              position_x += 15
            end
            position_y -= 15
          end
        elsif @exam.student #индивидуальная пересдача
          position_x = x_pos
          if @exam.test? #зачёт
            if @exam.student.ball(@discipline) < 55 || !@exam.student.pass_discipline?(@discipline)
              tableData << [1, @exam.student.person.full_name, @exam.student.id, '', '', '', '', '', '', '', '', "#{@exam.student.ball(@discipline)}+", '', '']
            else
              tableData << [1, @exam.student.person.full_name, @exam.student.id, '', '', '', '', '', '', '', '', @exam.student.ball(@discipline), 'зачтено', '']
              pdf.move_to [position_x + 242, position_y - 5.4]
              pdf.line_to [position_x + 249, position_y - 12.4]
              pdf.move_to [position_x + 249, position_y - 5.4]
              pdf.line_to [position_x + 242, position_y - 12.4]
            end
          elsif @exam.exam? #экзамен
            tableData << [1, @exam.student.person.full_name, @exam.student.id, '', '', '', '', '', '', '', '', '', '', '']
          else  #дифференцированный зачёт
            if @exam.student.ball(@discipline) < 85 || !@exam.student.pass_discipline?(@discipline)
              tableData << [index+1, @exam.student.person.full_name,  @exam.student.id, '', '', '', '', '', '', '', '', "#{@exam.student.ball(@discipline)}+", '', '']
            else
              tableData << [1, @exam.student.person.full_name, @exam.student.id, '', '', '', '', '', '', '', '', @exam.student.ball(@discipline), 'отлично', '']
              pdf.move_to [position_x + 272, position_y - 5.4]
              pdf.line_to [position_x + 279, position_y - 12.4]
              pdf.move_to [position_x + 279, position_y - 5.4]
              pdf.line_to [position_x + 272, position_y - 12.4]
            end
          end
          8.times do
            pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
            position_x += 15
          end
        elsif @exam.validation? #промежуточная аттестация
           excellent = 0
           good = 0
           fair = 0
           bad = 0
           if @discipline.is_active?
             group_students = @discipline.group.students.valid_for_today
           else
             group_students = Student.in_group_at_date(@discipline.group, Date.new((@discipline.semester == 1 ? @discipline.year : @discipline.year+1), (@discipline.semester == 1 ? 9 : 4), 15))
           end
           group_students.each_with_index do |student, index|
             position_x = x_pos
             ball = student.result(@discipline)
             case ball[:progress].round
                when 0..54
                  pdf.move_to [position_x + 317, position_y - 5.4]
                  pdf.line_to [position_x + 324, position_y - 12.4]
                  pdf.move_to [position_x + 324, position_y - 5.4]
                  pdf.line_to [position_x + 317, position_y - 12.4]
                  result = 'неудовл.'
                  bad += 1
                when  55..69
                   pdf.move_to [position_x + 302, position_y - 5.4]
                   pdf.line_to [position_x + 309, position_y - 12.4]
                   pdf.move_to [position_x + 309, position_y - 5.4]
                   pdf.line_to [position_x + 302, position_y - 12.4]
                   result = 'удовл.'
                   fair += 1
                when 70..85
                   pdf.move_to [position_x + 287, position_y - 5.4]
                   pdf.line_to [position_x + 294, position_y - 12.4]
                   pdf.move_to [position_x + 294, position_y - 5.4]
                   pdf.line_to [position_x + 287, position_y - 12.4]
                   result = 'хорошо'
                   good += 1
                when 86..100
                   pdf.move_to [position_x + 272, position_y - 5.4]
                   pdf.line_to [position_x + 279, position_y - 12.4]
                   pdf.move_to [position_x + 279, position_y - 5.4]
                   pdf.line_to [position_x + 272, position_y - 12.4]
                   result = 'отлично'
                   excellent += 1
              end
             tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', ball[:ball], result, '']

              8.times do
                pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
                position_x += 15
              end
              position_y -= 15
           end
        else #оригинальная форма контроля
          if @discipline.is_active?
            group_students = @discipline.group.students.valid_for_today
          else
            group_students = Student.in_group_at_date(@discipline.group, Date.new((@discipline.semester == 1 ? @discipline.year : @discipline.year+1), (@discipline.semester == 1 ? 9 : 4), 15))
          end
          group_students.each_with_index do |student, index|
            position_x = x_pos
            if @exam.test? #зачёт
              if student.ball(@discipline) < 55 || !student.pass_discipline?(@discipline)
                tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', "#{student.ball(@discipline)}+", '', '']
                # tableData << [index+1, 'Фамилия Имя Отчество', 'XXXXX', '', '', '', '', '', '', '', '', "#{student.ball(@discipline)}+", '', '']
              else
                tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', student.ball(@discipline), 'зачтено', '']
                # tableData << [index+1, 'Фамилия Имя Отчество', 'XXXXX', '', '', '', '', '', '', '', '', student.ball(@discipline), 'зачтено', '']
                pdf.move_to [position_x + 242, position_y - 5.4]
                pdf.line_to [position_x + 249, position_y - 12.4]
                pdf.move_to [position_x + 249, position_y - 5.4]
                pdf.line_to [position_x + 242, position_y - 12.4]
              end
            elsif @exam.exam? #экзамен
              tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', '', '', '']
              # tableData << [index+1, 'Фамилия Имя Отчество', 'XXXXX', '', '', '', '', '', '', '', '', '', '', '']
            else #дифференцированный зачёт
              if student.ball(@discipline) < 85 || !student.pass_discipline?(@discipline)
                tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', "#{student.ball(@discipline)}+", '', '']
              else
                tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', student.ball(@discipline), 'отлично', '']
                pdf.move_to [position_x + 272, position_y - 5.4]
                pdf.line_to [position_x + 279, position_y - 12.4]
                pdf.move_to [position_x + 279, position_y - 5.4]
                pdf.line_to [position_x + 272, position_y - 12.4]
              end
            end
            8.times do
              pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
              position_x += 15
            end
            position_y -= 15
          end
        end

      # Для дисциплин, создаваемых дирекциями
      else
        height = 35
        tableData = [[{content: '№', rowspan: 2}, {content: 'Фамилия, имя, отчество', rowspan: 2},
                      {content: 'Номер', rowspan: 2}, {content:  pdf.text_box('Зачтено', at: [x_pos + 239, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Не зачтено', at: [x_pos + 254, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Отлично', at: [x_pos + 269, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Хорошо',at: [x_pos + 284, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Удовл.', at: [x_pos + 299, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неуд.', at: [x_pos + 314, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Недопущ.', at: [x_pos + 329, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неявка', at: [x_pos + 344, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: 'Результат', colspan: 2}, {content: 'Подпись экзаменатора', rowspan: 2}], %w(Цифрой Прописью)]

        position_y = y_pos

        st = []
        if @exam.is_repeat?
          if @exam.student
            st << @exam.student
          else
            @exam.students.each { |s| st << s.student }
          end
        else
          if @discipline.is_active?
            group_students = @discipline.group.students.valid_for_today
          else
            group_students = Student.in_group_at_date(@discipline.group, Date.new((@discipline.semester == 1 ? @discipline.year : @discipline.year+1), (@discipline.semester == 1 ? 9 : 4), 15))
          end
          group_students.each { |s| st << s }
        end

        st.each_with_index do |student, index|
            position_x = x_pos
            tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', '', '', '']
            8.times do
              pdf.rectangle [position_x + 242, position_y - 5.4], 7, 7
              position_x += 15
            end
            position_y -= 15
        end

      end

      pdf.font_size 10 do
        pdf.table tableData, header: true, cell_style: { padding: [0, 0, 2, 2] } do
         row(0).height = height
         column(0).width = 24
         column(1).width = 174.28 + 26 #157
         column(2).width = 40 #35
         (3..10).each do |i|
           column(i).width = 15
         end
         column(11).width = 40 + 7
         column(12).width = 48 #60
         column(13).width = 65 #80
        end
      end

      pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 70], width: pdf.bounds.width do
        if @exam.is_repeat?
           pdf.move_down 15
           pdf.indent (@exam.repeat == Study::Exam::COMMISSION_REPEAT ? 32 : 28)  do
            pdf.text "Дата сдачи: ______________________                                                          Ведомость действительна до #{(@exam.date+3.days).sunday? ? (l (@exam.date+3.days).next) : ((@exam.date+3.days).saturday? ? (l (@exam.date+3.days).next_day(2)) : (l (@exam.date+3.days)))}"
           end
           pdf.move_down 18
        else
          if @exam.validation? && @discipline.brs?
            if @discipline.is_active?
              group_students = @discipline.group.students.valid_for_today
            else
              group_students = Student.in_group_at_date(@discipline.group, Date.new((@discipline.semester == 1 ? @discipline.year : @discipline.year+1), (@discipline.semester == 1 ? 9 : 4), 15))
            end
            footData = [['Явилось', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Зачтено', 'Не зачтено', 'Недопущ.', 'Неявка', 'Ср. балл'],
                              [group_students.length, excellent, good, fair, bad, '—', '—', '—', '—', (5*excellent + 4*good + 3*fair + 2*bad)/group_students.length]]
          else
            footData = [['Явилось', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Зачтено', 'Не зачтено', 'Недопущ.', 'Неявка', 'Ср. балл'],
                      [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
          end
          pdf.table footData, width: pdf.bounds.width,
                          cell_style: { padding: 2}
          pdf.move_down 12
        end
        pdf.text "#{@exam.repeat == Study::Exam::COMMISSION_REPEAT ? 'Подписи членов комиссии' : 'Подпись преподавателя(лей)'} _____________________________           Директор института _____________________________", align: :center
      end
  end

  if @discipline.brs? && (Study::Exam.finals.include? @exam)
    if @exam.exam?
      pdf.start_new_page
    else
      pdf.start_new_page layout: :landscape #если зачёты, альбомная ориентация
    end

    pdf.font_size 9 do
      pdf.text 'Федеральное государственное бюджетное образовательное учреждение высшего профессионального образования', align: :center
    end
    pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center
    pdf.move_down 10
    pdf.text "ПРИЛОЖЕНИЕ К ЭКЗАМЕНАЦИОННОЙ ВЕДОМОСТИ № #{@exam.id}", align: :center
    # pdf.text "ПРИЛОЖЕНИЕ К ЭКЗАМЕНАЦИОННОЙ ВЕДОМОСТИ № XXXX", align: :center
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
        # pdf.text_box "#{l Date.today }", at: [(@exam.is_repeat? ? 431 : 450), 750 - 25]
         if @exam.is_repeat?
            pdf.text_box " #{@exam.repeat_type}", at: [77, 750 - 40]
         else
           pdf.text_box " #{@exam.name}", at: [77, 750 - 40]
         end

        pdf.text_box "#{@discipline.name}", at: [59, 750 - 55]
        # pdf.text_box "Название дисциплины", at: [59, 750 - 55]
        pdf.text_box "#{group.name}", at: [405, 750 - 40]
        # pdf.text_box "Буквенно-цифровой шифр группы", at: [405, 750 - 40]
        pdf.text_box "#{@discipline.lead_teacher.full_name}", at: [199, 750 - 70]
        # pdf.text_box "Фамилия Имя Отчество", at: [199, 750 - 70]
      end

      applicationTable = [[{content: '№', rowspan: 2}, {content: 'Фамилия, имя, отчество', rowspan: 2},
                          {content: 'Номер', rowspan: 2}, {content: 'Баллы за семестр', rowspan: 2}, {content: 'Нужно набрать на экзамене в баллах', colspan: 4}],
                          ['«Отлично»', '«Хорошо»', '«Удовл.»', '«Неуд.»']]
      pdf.font_size 10 do
        if @exam.is_mass_repeat? || @exam.is_individual_repeat?
          @exam.students.each_with_index do |student, index|
            if student.student.ball(@discipline) < 55 || !student.student.pass_discipline?(@discipline)
              applicationTable << [index+1, student.student.person.full_name, student.student.id, student.student.ball(@discipline), '—', '—', '—', '0 — 100']
            else
            result_5 = @discipline.final_exam.predication(5, student.student.ball(@discipline))
            result_4 = @discipline.final_exam.predication(4, student.student.ball(@discipline))
            result_3 = @discipline.final_exam.predication(3, student.student.ball(@discipline))
            result_2 = @discipline.final_exam.predication(2, student.student.ball(@discipline))
            applicationTable << [index+1, student.student.person.full_name, student.student.id, student.student.ball(@discipline), "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
            end
          end
        elsif @exam.student
          if @exam.student.ball(@discipline) < 55 || !@exam.student.pass_discipline?(@discipline)
            applicationTable << [index+1, @exam.student.person.full_name, @exam.student.id, @exam.student.ball(@discipline), '—', '—', '—', '0 — 100']
          else
            result_5 = @discipline.final_exam.predication(5, @exam.student.ball(@discipline))
            result_4 = @discipline.final_exam.predication(4, @exam.student.ball(@discipline))
            result_3 = @discipline.final_exam.predication(3, @exam.student.ball(@discipline))
            result_2 = @discipline.final_exam.predication(2, @exam.student.ball(@discipline))
            applicationTable << [1, @exam.student.person.full_name, @exam.student.id, @exam.student.ball(@discipline), "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
          end
          else
          if @discipline.is_active?
            group_students = @discipline.group.students.valid_for_today
          else
            group_students = Student.in_group_at_date(@discipline.group, Date.new((@discipline.semester == 1 ? @discipline.year : @discipline.year+1), (@discipline.semester == 1 ? 9 : 4), 15))
          end
          group_students.each_with_index do |student, index|
            # # Для примера
            # if student.ball(@discipline) == 0.0
            #   ball = rand(100)*1.0
            #   result_5 = @discipline.final_exam.predication(5, ball)
            #   result_4 = @discipline.final_exam.predication(4, ball)
            #   result_3 = @discipline.final_exam.predication(3, ball)
            #   result_2 = @discipline.final_exam.predication(2, ball)
            # else
            if student.ball(@discipline) < 55 || !student.pass_discipline?(@discipline)
              applicationTable << [index+1, student.person.full_name, student.id, student.ball(@discipline), '—', '—', '—', '0 — 100']
            else
              ball = student.ball(@discipline)
              result_5 = @discipline.final_exam.predication(5, ball)
              result_4 = @discipline.final_exam.predication(4, ball)
              result_3 = @discipline.final_exam.predication(3, ball)
              result_2 = @discipline.final_exam.predication(2, ball)
            # end
              applicationTable << [index+1, student.person.full_name, student.id, student.ball(@discipline), "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
            end
            # applicationTable << [index+1, 'Фамилия Имя Отчество', 'XXXXX', ball, "#{result_5[:min]} — #{result_5[:max]}", "#{result_4[:min]} — #{result_4[:max]}", "#{result_3[:min]} — #{result_3[:max]}", "#{result_2[:min]} — #{result_2[:max]}"]
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
        # pdf.text_box "#{l Date.today}", at: [(@exam.is_repeat? ? 631 : 650), 500 - 25]
         if @exam.is_repeat?
            pdf.text_box " #{@exam.repeat_type}", at: [77, 500 - 40]
         else
           pdf.text_box " #{@exam.name}", at: [77, 500 - 40]
         end

        pdf.text_box "#{@discipline.name}", at: [59, 500 - 55]
        # pdf.text_box "Название дисциплины", at: [59, 500 - 55]
        pdf.text_box "#{group.name}", at: [605, 500 - 40]
        # pdf.text_box "Буквенно-цифровой шифр группы", at: [605, 500 - 40]
        pdf.text_box "#{@discipline.lead_teacher.full_name}", at: [199, 500 - 70]
        # pdf.text_box "Фамилия Имя Отчество", at: [199, 500 - 70]
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
        if @exam.is_mass_repeat? || @exam.is_individual_repeat?
          index = 1
          @exam.students.each do |student|
            if (!(student.student.ball(@discipline) < 55) && @exam.test? && student.student.pass_discipline?(@discipline))
              next
            end
            applicationTable << [index, student.student.person.full_name, student.student.id, student.student.ball(@discipline)]
            @discipline.checkpoints.each do |checkpoint|
              applicationTable[applicationTable.length - 1] << "#{checkpoint.min}/#{checkpoint.max}"
              applicationTable[applicationTable.length - 1] << "#{checkpoint.marks.by_student(student.student).last ? checkpoint.marks.by_student(student.student).last.mark : 0}"
              applicationTable[applicationTable.length - 1] << ''
            end
            index+=1
          end
        elsif @exam.student
          applicationTable << [1, @exam.student.person.full_name, @exam.student.id, @exam.student.ball(@discipline)]
          @discipline.checkpoints.each do |checkpoint|
            applicationTable[applicationTable.length - 1] << "#{checkpoint.min}/#{checkpoint.max}"
            applicationTable[applicationTable.length - 1] << "#{checkpoint.marks.by_student(@exam.student).last ? checkpoint.marks.by_student(@exam.student).last.mark : 0}"
            applicationTable[applicationTable.length - 1] << ''
          end
        else
          index = 1
          if @discipline.is_active?
            group_students = @discipline.group.students.valid_for_today
          else
            group_students = Student.in_group_at_date(@discipline.group, Date.new((@discipline.semester == 1 ? @discipline.year : @discipline.year+1), (@discipline.semester == 1 ? 9 : 4), 15))
          end
          group_students.each do |student|
            if (!(student.ball(@discipline) < 55) && student.pass_discipline?(@discipline) && @exam.test?) || (!(student.ball(@discipline) < 85) && student.pass_discipline?(@discipline) && @exam.graded_test?)
              next
            end
            applicationTable << [index, student.person.full_name, student.id, student.ball(@discipline)]
            # applicationTable << [index, 'Фамилия Имя Отчество', 'XXXXX', student.ball(@discipline)]
            @discipline.checkpoints.each do |checkpoint|
              applicationTable[applicationTable.length - 1] << "#{checkpoint.min}/#{checkpoint.max}"
              applicationTable[applicationTable.length - 1] << "#{checkpoint.marks.by_student(student).last ? checkpoint.marks.by_student(student).last.mark : 0}"
              applicationTable[applicationTable.length - 1] << ''
            end
            index+=1
          end
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
