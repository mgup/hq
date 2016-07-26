prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :landscape do |pdf|

  render 'pdf/font', pdf: pdf
  key = true
  payment_categories = params[:type] == '1' ? [:paid, :not_paid] : [:not_paid]
  form_categories = params[:type] == '1' ? [:z_form, :oz_form, :o_form] : [:o_form]
  @items.each do |i|
    payment_categories.each do |payment|
      form_categories.each do |form|
        if '4' == params[:type]
          applications = i.applications.send(form).send(payment).find_all { |a| a.created_at < Date.new(2016, 7, 26) }
        elsif '5' == params[:type]
          applications = i.applications.send(form).send(payment).find_all { |a| a.created_at >= Date.new(2016, 7, 26) }
        else
          applications = i.applications.send(form).send(payment).actual
        end

        if applications.empty?
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
          pdf.text "#{applications.first.education_form_name} форма обучения, #{applications.first.budget_name}"

          pdf.font_size 10 do
            pdf.table [
                        ['Председатель приемной комиссии', 'Антипов К.В.', '____________________________'],
                        ['Заместитель председателя', 'Кожевников Г.В.', '____________________________'],
                        ['Зам. председателя по приему в аспирантуру', 'Назаров В.Г.', '____________________________'],
                        ['Зам. председателя по учету индивидуальных достижений', 'Антипов С.В.', '____________________________'],
                        ['Ответственный секретарь', 'Хохлогорская Е.Л.', '____________________________'],
                        ['Заместитель ответственного секретаря', 'Дмитриев Я.В.', '____________________________'],
                        ['Заместитель ответственного секретаря по бюджетному приему', 'Щербакова Ю.Ю.', '____________________________'],
                        ['Заместитель ответственного секретаря по приему в аспирантуру', 'Ситникова Т.А.', '____________________________'],
                        ['Заместитель ответственного секретаря по проведению вступительных испытаний', 'Алиева Д.В.', '____________________________'],
                        ['Заместитель ответственного секретаря по учету индивидуальных достижений', 'Логинова Ю.А.', '____________________________'],
                        ['Заместитель ответственного секретаря по приему иностранных граждан', 'Иванова И.А.', '____________________________']
                      ], cell_style: {border_color: 'ffffff', padding: [1, 0]}, width: pdf.bounds.width do
              column(0).width = 510
            end
          end

          pdf.move_down 8
          pdf.text 'Члены приемной комиссии'

          pdf.font_size 10 do
            pdf.table [
                        ['Корытов О.В.', '____________________________', ' ', 'Горлов С.Ю.', '____________________________', ' ', 'Винокур А.И.', '____________________________'],
                        ['Столяров А.А.', '____________________________', ' ', 'Цепилова В.А.', '____________________________', ' ', 'Рекус И.Г.', '____________________________'],
                        ['Махашвили Г.Д.', '____________________________', ' ', 'Попова Е.А.', '____________________________', ' ', 'Чернов А.Н.', '____________________________'],
                        ['Бабкин Ф.В.', '____________________________', ' ', 'Подколзин Е.Н.', '____________________________', ' ', 'Сугачкова Т.В.', '____________________________'],
                        ['Резников К.С.', '____________________________', ' ', 'Шаронин П.Н.', '____________________________', ' ', 'Яковлев Р.В.', '____________________________'],
                        ['Галицкий Д.В.', '____________________________', ' ', 'Иванова А.Е.', '____________________________', ' ', 'Токмаков Б.В.', '____________________________'],
                        ['Бондарь И.А.', '____________________________', ' ', 'Коростелина В.В.', '____________________________', ' ', 'Гордеева Е.Е.', '____________________________'],
                        ['Яковлева О.М.', '____________________________', ' ', 'Шерстнев Г.К.', '____________________________', ' ', 'Пронина Е.Н.', '____________________________'],
                        ['Журавлева Г.Н.', '____________________________', ' ', 'Малков В.В.', '____________________________', ' ', 'Прыгина Н.Ю.', '____________________________'],
                        ['Тихонова М.О.', '____________________________', ' ', ' ', ' ', ' ', ' '],
                      ], cell_style: {border_color: 'ffffff', padding: 0}, width: pdf.bounds.width
          end

          exams = i.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam.name }
          data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]
          exams.each {|e|  data.first << e}
          data.first << 'Решение комиссии'

          index = 0
          applications.each do |ap|
            # next unless ap.entrant.visible?
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
              (3 + exams.size) => 50
            }
            exams.each_with_index do |name, i|
              # Название предмета состоит из одного слова.
              if 1 == name.split(' ').size
                column_widths[3 + i] = pdf.width_of(name) + 10
              end
            end
            pdf.table data, width: pdf.bounds.width, column_widths: column_widths
          end
        end
      end
    end
  end
end

