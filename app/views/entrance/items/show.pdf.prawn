prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :landscape do |pdf|

  render 'pdf/font', pdf: pdf

  use = []
  internal = []
  @item.applications.each do |ap|
    if ap.entrant.exam_results.internal.empty?
      use << ap
    else
      internal << ap
    end
  end
  key = true
  [internal, use].each do |apps|
    if apps.empty?
     next
    else
      pdf.start_new_page unless key
      key = false
    end
    pdf.font_size 11 do

    pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
    pdf.move_down 5
    pdf.text "#{params[:name]}", style: :bold, align: :center
    pdf.move_down 5
    n = apps.first.number[3,2]
    if n == 'ЖД' || n == 'ГД' || n == 'ГВ' || n == 'ЗД'
      date = '«5» июля'
    elsif apps == use
      date = '«25» июля'
    else
      date = '«10» июля'
    end
    pdf.table [['№ __________________', "от #{date} 2014 г."]], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
      column(0).width = 600
    end
    pdf.move_down 8
    pdf.text "<strong>Направление:</strong> #{@item.direction.new_code} «#{@item.direction.name}»", inline_format: true
    pdf.text "<strong>Форма обучения:</strong> #{@item.form_name}", inline_format: true
    pdf.text "<strong>Основа обучения:</strong> #{@item.budget_name}", inline_format: true

    pdf.font_size 10 do
      pdf.table [
                    ['Председатель приёмной комиссии', 'Антипов К.В.', '______________________'],
                    ['Зам. председателя приёмной комиссии', 'Маркелова Т.В.', '______________________'],
                    ['Зам. председателя по приёму в аспирантуру', 'Назаров В.Г.', '______________________'],
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

    pdf.move_down 8
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

    exams = @item.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam.name }
    data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]
    exams.each {|e|  data.first << e}
    data.first << 'Решение комиссии'

    apps.each_with_index do |ap, index|
      data << ["#{index+1}", ap.number, ap.entrant.full_name]
      ap.abitexams.collect{|x| (x.use? ? x.score : '')}.each{ |x| data.last << x }
      data.last << 'допустить'
    end
    pdf.font_size 10 do
      pdf.start_new_page
      pdf.table data, width: pdf.bounds.width
    end
    end
  end
end

