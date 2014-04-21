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
  pdf.text_box 'ЭКЗАМЕНАЦИОННАЯ (ЗАЧЁТНАЯ) ВЕДОМОСТЬ №', at: [120, 842 - 70]

  group = @exam.discipline.group

  pdf.font_size 10 do
    pdf.text_box 'Семестр:', at: [0, 750]
    pdf.text_box 'Форма контроля:', at: [0, 750 - 15]
    pdf.text_box 'Дисциплина:', at: [0, 750 - 30]
    pdf.text_box 'Фамилия, имя, отчество преподавателя(лей):', at: [0, 750 - 45]
    pdf.text_box 'Дата проведения:', at: [370, 750]
    pdf.text_box 'Группа:', at: [370, 750 - 15]

   pdf.text_box "#{@exam.date ? (l @exam.date) : 'неизвестно'}", at: [450, 750]
   pdf.text_box "#{@exam.name}", at: [77, 750 - 15]
   pdf.text_box "#{@discipline.name}", at: [59, 750 - 15 * 2]
   pdf.text_box "#{group.name}", at: [405, 750 - 15]
   pdf.text_box "#{@discipline.lead_teacher.full_name}", at: [199, 750 - 45]
  end


  pdf.font_size 10 do


      y_pos = 630
      x_pos = 26
      size = 8

      pdf.fill_and_stroke_rectangle [0, 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14, 14], 14, 14
      pdf.fill_and_stroke_rectangle [0, 842 - 28 - 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14, 842 - 28 - 14], 14, 14
      pdf.fill_and_stroke_rectangle [595 - 56 - 14, 750 - 15 * 3], 14, 14

      pdf.move_down 110

      if @discipline.brs?
        height = 50
        tableData = [[
          pdf.text_box('№', at: [x_pos - 21, y_pos+30], size: size, height: 100),
          pdf.text_box('Фамилия, имя, отчество', at: [x_pos + 3, y_pos+30], size: size, height: 100),
          pdf.text_box('Номер', at: [x_pos + 198, y_pos+30], size: size, height: 100),
          pdf.text_box('Зачтено', at: [x_pos + 240, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Не зачтено', at: [x_pos + 255, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Отлично', at: [x_pos + 270, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Хорошо',at: [x_pos + 285, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Удовл.', at: [x_pos + 300, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Неуд.', at: [x_pos + 315, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Недопущ.', at: [x_pos + 330, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Неявка', at: [x_pos + 345, y_pos], rotate: 90, size: size, width: 100),
          pdf.text_box('Набранный балл за семестр', at: [x_pos + 360, y_pos], rotate: 90, size: size, width: 50),
          pdf.text_box('Результат прописью', at: [x_pos + 405, y_pos+30],  size: size, width: 50, height: 100),
          pdf.text_box('Подпись экзаменатора', at: [x_pos + 455, y_pos+30], size: size, width: 60, height: 100)
        ]]
        position_y = y_pos
        @discipline.group.students.each_with_index do |student, index|
          position_x = x_pos
          tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', student.ball(@discipline).round, '', '']
          8.times do
            pdf.rectangle [position_x + 242, position_y - 7], 7, 7
            position_x += 15
          end
          position_y -= 13.95
        end
      else
        height = 35
        tableData = [[{content: '№'}, {content: 'Фамилия, имя, отчество', rowspan: 2},
                      {content: 'Номер', rowspan: 2}, {content:  pdf.text_box('Зачтено', at: [x_pos + 205, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Не зачтено', at: [x_pos + 220, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Отлично', at: [x_pos + 235, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Хорошо',at: [x_pos + 250, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Удовл.', at: [x_pos + 265, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неуд.', at: [x_pos + 280, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Недопущ.', at: [x_pos + 295, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: pdf.text_box('Неявка', at: [x_pos + 310, y_pos], rotate: 90, size: size, width: 100), rowspan: 2},
                      {content: 'Экзамен', colspan: 2}, {content: 'Подпись экзаменатора', rowspan: 2}], ['Цифрой', 'Прописью']]

        position_y = y_pos
        @discipline.group.students.each_with_index do |student, index|
          position_x = x_pos
          tableData << [index+1, student.person.full_name, student.id, '', '', '', '', '', '', '', '', '', '', '']
          8.times do
            pdf.rectangle [position_x + 205, position_y - 6], 9, 9
            position_x += 15
          end
          position_y -= 27
        end
      end

      pdf.font_size 10 do
        pdf.table tableData, header: true, cell_style: { padding: [0, 0, 2, 0] } do
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
        footData = [['Явилось', 'Отлично', 'Хорошо', 'Удовл.', 'Неуд.', 'Зачтено', 'Не зачтено', 'Недопущ.', 'Неявка', 'Ср. балл'],
                    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']]
        pdf.table footData, width: pdf.bounds.width,
                        cell_style: { padding: 2}
        pdf.move_down 10
        pdf.text "Подпись преподавателя ________________________           Директор института ________________________", align: :center
        end
  end
end