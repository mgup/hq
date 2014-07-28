prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :landscape do |pdf|

  render 'pdf/font', pdf: pdf
  key = true
  @items.each do |i|
    if i.applications.empty?
     next
    else
      pdf.start_new_page unless key
      key = false
    end
    pdf.font_size 11 do

    pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
    pdf.move_down 4
    pdf.text 'допуска к вступительным испытаниям', style: :bold, align: :center
    pdf.table [['№ __________________', @date]], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
      column(0).width = 600
    end
    pdf.move_down 2
    pdf.text "#{i.direction.new_code} «#{i.direction.name}»"
    pdf.text "#{i.form_name} форма обучения, #{i.budget_name}"

    pdf.font_size 10 do
      pdf.table [
                    ['Председатель приемной комиссии', 'Антипов К.В.', '______________________'],
                    ['Зам. председателя приемной комиссии', 'Маркелова Т.В.', '______________________'],
                    ['Зам. председателя по приему в аспирантуру', 'Назаров В.Г.', '______________________'],
                    ['Ответственный секретарь', 'Хохлогорская Е.Л.', '______________________'],
                    ['Заместитель ответственного секретаря по бюджетному приему', 'Боцман Ю.Ю.', '______________________'],
                    ['Заместитель ответственного секретаря по приему в аспирантуру', 'Ситникова Т.А.', '______________________'],
                    ['Заместитель ответственного секретаря по проведению вступительных испытаний', 'Алиева Д.В.', '______________________'],
                    ['Заместитель ответственного секретаря по приему иностранных граждан', 'Иванова И.А.', '______________________'],
                    ['Заместитель ответственного секретаря', 'Саркисова Е.Ю.', '______________________']
                ], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
        column(0).width = 510
      end
    end

    pdf.move_down 2
    pdf.text 'Члены приемной комиссии'

    pdf.font_size 10 do
      pdf.table [
                    ['Корытов О.В.', '______________________', ' ', 'Горлов С.Ю.', '______________________', ' ', 'Винокур А.И.', '______________________'],
                    ['Столяров А.А.', '______________________', ' ', 'Кулаков В.В.', '______________________', ' ', 'Сидорова Н.В.', '______________________'],
                    ['Миронова Г.В.', '______________________', ' ', 'Перевалова Е.В.', '______________________', ' ', 'Дмитриев Я.В.', '______________________'],
                    ['Гордеева Е.Е.', '______________________', ' ', 'Шляга В.С.', '______________________', ' ', 'Галицкий Д.В.', '______________________'],
                    ['Голева О.П.', '______________________', ' ', 'Толутанова Ю.Н.', '______________________', ' ', 'Токмаков Б.В.', '______________________'],
                    ['Яковлев А.В.', '______________________', ' ', 'Яковлев Р.В.', '______________________', '', '', '']
                ], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width
    end

    exams = i.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam.name }
    data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]
    exams.each {|e|  data.first << e}
    data.first << 'Решение комиссии'

    index = 0
    i.applications.each do |ap|
      if @type == 2
        next if ap.abitexams.select{|e| e ? e.university? : false}.empty?
      elsif @type == 3
        next unless ap.abitexams.select{|e| e ? e.university? : false}.empty?
      elsif ap.entrant.id == 1850
        next
      end
      index += 1
      data << ["#{index}", ap.number, ap.entrant.full_name]
      ap.abitexams.collect{|x| (x ? (x.use? ? x.score : '') : '')}.each{ |x| data.last << x }
      data.last << 'допустить'
    end
    pdf.font_size 8 do
      pdf.move_down 2
      column_widths = {
        0 => 30,
        1 => 60,
        2 => 170,
        (3 + exams.size) => 34
      }
      exams.each_with_index do |name, i|
        # Название предмета состоит из одного слова.
        if 1 == name.split(' ').size
          column_widths[3 + i] = pdf.width_of(name) + 10
        end
      end
      pdf.table data, width: pdf.bounds.width
    end
    end
  end
end

