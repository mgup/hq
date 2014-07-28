item = group.items.first

pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
pdf.text 'о допуске к участию в конкурсе', style: :bold, align: :center

if 12014 == @campaign.id
  date = '13 июля'
elsif 18 == item.education_level_id
  date = '17 июля'
else
  date = '25 июля'
end

pdf.table [['№ __________________', "от #{date} 2014 г."]], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
  column(0).width = 600
end
pdf.move_down 8
pdf.text "<strong>Направление:</strong> #{item.direction.new_code} «#{item.direction.name}»", inline_format: true
pdf.text "<strong>Форма обучения:</strong> #{item.form_name}", inline_format: true
pdf.text "<strong>Основа обучения:</strong> #{item.budget_name}", inline_format: true

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

pdf.move_down 3
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

exams = item.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam.name }

data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]
exams.each {|e|  data.first << e}
data.first << 'Условия участия в конкурсе'
data.first << 'Решение комиссии'

appls = item.applications.for_rating
appls.sort { |a, b| a.number <=> b.number }.each_with_index do |ap, index|
  data << ["#{index+1}", ap.number, ap.entrant.full_name]
  ap.abitexams.collect{ |x| x.score }.each{ |x| data.last << x }

  benefit = ap.benefits.first
  if benefit && (benefit.benefit_kind.out_of_competition? || benefit.benefit_kind.special_rights?)
    data.last << benefit.benefit_kind.short_name
  else
    if ap.competitive_group_target_item
      data.last << 'Квота целевого приема'
    else
      data.last << 'По конкурсу'
    end
  end

  if 0 != ap.pass_min_score
    data.last << 'допустить'
  else
    data.last << 'не допустить'
  end
end

pdf.font_size 8 do
  pdf.table data, width: pdf.bounds.width
end
