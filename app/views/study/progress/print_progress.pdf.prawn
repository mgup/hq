                            prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Успеваемость #{@group.name} на #{l Date.today}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: "Ведомость контроля успеваемости"

  if params[:discipline]
    y_pos = 558
    discipline = Study::Discipline.find(params[:discipline])
    headData = [["Учебный год: #{Study::Discipline::CURRENT_STUDY_YEAR}/#{Study::Discipline::CURRENT_STUDY_YEAR+1}",
                "Семестр: #{Study::Discipline::CURRENT_STUDY_TERM == 1 ? 'I' : 'II'}"],
                 ['Форма контроля: текущая аттестация',
                  "Контрольная дата: #{discipline.validation.date? ? (l discipline.validation.date) : 'неизвестно'}" ],
                 ["Дисциплина: #{discipline.name}",
                  "Группа: #{@group.name}"],
                 ["Преподаватель: #{discipline.lead_teacher.full_name}", '']]
  else
    y_pos = 572
    headData = [["Семестр: #{Study::Discipline::CURRENT_STUDY_TERM}, #{Study::Discipline::CURRENT_STUDY_YEAR}-#{Study::Discipline::CURRENT_STUDY_YEAR+1} учебного года", 'Дата проведения: неизвестно' ],
                        ['Форма контроля: аттестация', "Группа: #{@group.name}"],
                        ['Успеваемость по всем предметам', '']]
  end
  plus =  pdf.font.compute_width_of(discipline.name) > 200 ? 12 : 0
  y_pos -= plus
    pdf.font_size 9 do
        pdf.table headData, header: true, width: pdf.bounds.width,
                  cell_style: { padding: 2, border_color: "ffffff" } do
                   column(0).width = 350
        end
    end

  pdf.move_down 13


  x_pos = 5
  size = 8
  height = 50
  data = [[
            pdf.text_box('№', at: [x_pos - 2, y_pos+30], size: size, height: 100),
            pdf.text_box('Фамилия, имя, отчество', at: [x_pos + 20, y_pos+30], size: size, height: 100),
            pdf.text_box('Номер', at: [x_pos + 172, y_pos+30], size: size, height: 100),
            pdf.text_box('Зачтено', at: [x_pos + 205, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Не зачтено', at: [x_pos + 220, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Отлично', at: [x_pos + 235, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Хорошо',at: [x_pos + 250, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Удовл.', at: [x_pos + 265, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Неуд.', at: [x_pos + 280, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Недопущ.', at: [x_pos + 295, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Неявка', at: [x_pos + 310, y_pos], rotate: 90, size: size, width: 100),
            pdf.text_box('Набранный балл', at: [x_pos + 325, y_pos], rotate: 90, size: size, width: 50),
            pdf.text_box('Результат прописью', at: [x_pos + 365, y_pos+30],  size: size, width: 50, height: 100),
            pdf.text_box('Подпись экзаменатора', at: [x_pos + 425, y_pos+30], size: size, width: 60, height: 100)
  ]]

  position_y = y_pos
  excellent = 0
  good = 0
  fair = 0
  bad = 0
  @group.students.each_with_index do |student, index|
     position_x = x_pos
      ball = student.result(discipline)[:width]
      case ball.round
         when 0..54
           pdf.move_to [position_x + 280, position_y - 7]
           pdf.line_to [position_x + 289, position_y - 16]
           pdf.move_to [position_x + 289, position_y - 7]
           pdf.line_to [position_x + 280, position_y - 16]
           result = 'неудовл.'
           bad += 1
         when  55..69
            pdf.move_to [position_x + 265, position_y - 7]
            pdf.line_to [position_x + 274, position_y - 16]
            pdf.move_to [position_x + 274, position_y - 7]
            pdf.line_to [position_x + 265, position_y - 16]
            result = 'удовл.'
            fair += 1
         when 70..85
            pdf.move_to [position_x + 250, position_y - 7]
            pdf.line_to [position_x + 259, position_y - 16]
            pdf.move_to [position_x + 259, position_y - 7]
            pdf.line_to [position_x + 250, position_y - 16]
            result = 'хорошо'
            good += 1
         when 86..Float::INFINITY
            pdf.move_to [position_x + 235, position_y - 7]
            pdf.line_to [position_x + 244, position_y - 16]
            pdf.move_to [position_x + 244, position_y - 7]
            pdf.line_to [position_x + 235, position_y - 16]
            result = 'отлично'
            excellent += 1
       end
      data << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', ball.round, result, '']



     8.times do
      pdf.rectangle [position_x + 205, position_y - 7], 9, 9
      position_x += 15
     end
     position_y -= 14.37
  end

  pdf.font_size 8 do
    pdf.table data, header: true,
              column_widths: [15, 200, 32], cell_style: { padding: 2 } do
      row(0).height = height
      column(1).width = 157
      column(2).width = 35
      8.times.each do |i|
        column(i+3).width = 15
      end
      column(11).width = 40
      column(12).width = 60
      column(13).width = 82
    end
  end

  pdf.font_size 9 do
     pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 60], width: pdf.bounds.width do
        footData = [['Явилось', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Зачтено', 'Не зачтено', 'Недопущ.', 'Неявка', 'Ср. балл'],
                    [@group.students.length, excellent, good, fair, bad, '—', '—', '—', '—', (5*excellent + 4*good + 3*fair + 2*bad)/@group.students.length]]
        pdf.table footData, width: pdf.bounds.width, cell_style: { padding: [2,4]}
        pdf.move_down 12
        pdf.text 'Подпись преподавателя _________________________________                     Директор института _________________________________', align: :center
     end
   end
end