item = group.items.first
[:not_paid].each do |payment|
  [:z_form, :oz_form, :o_form].each do |form|

    applications = item.applications.send(form).send(payment)
    # applications = item.applications.where('created_at < 2015-07-25').send(form).send(payment)

    next unless applications.any?
    pdf.start_new_page
    pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
    pdf.text 'о допуске к участию в конкурсе', style: :bold, align: :center

    if 12015 == @campaign.id
      date = '13 июля'
    elsif 18 == applications.first.education_form_id
      date = '17 июля'
    else
      date = '25 июля'
    end

    date = '27 июля'

    pdf.table [['№ __________________', "от #{date} 2015 г."]], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
      column(0).width = 600
    end
    pdf.move_down 8
    pdf.text "#{item.direction.new_code}, #{item.direction.name}"
    pdf.text "#{applications.first.education_form_name} форма обучения, #{applications.first.budget_name}"

    pdf.font_size 10 do
      pdf.table [
                  ['Председатель приемной комиссии', 'Антипов К.В.', '____________________________'],
                  ['Зам. председателя приемной комиссии', 'Маркелова Т.В.', '____________________________'],
                  ['Зам. председателя по приему в аспирантуру', 'Назаров В.Г.', '____________________________'],
                  ['Проректор по АПР и БОП', 'Рачинский Д.В.', '____________________________'],
                  ['Ответственный секретарь', 'Хохлогорская Е.Л.', '____________________________'],
                  ['Заместитель ответственного секретаря по бюджетному приему', 'Боцман Ю.Ю.', '____________________________'],
                  ['Заместитель ответственного секретаря по приему в аспирантуру', 'Ситникова Т.А.', '____________________________'],
                  ['Заместитель ответственного секретаря по проведению вступительных испытаний', 'Алиева Д.В.', '____________________________'],
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
                  ['Столяров А.А.', '____________________________', ' ', 'Подтуркина Е.А.', '____________________________', ' ', 'Алферова О.Л.', '____________________________'],
                  ['Резников К.С.', '____________________________', ' ', 'Шаронин П.Н.', '____________________________', ' ', 'Дмитриев Я.В.', '____________________________'],
                  ['Галицкий Д.В.', '____________________________', ' ', 'Гордеева Е.Е.', '____________________________', ' ', 'Токмаков Б.В.', '____________________________'],
                  ['Шляга В.С.', '____________________________', ' ', 'Соколова И.С.', '____________________________', ' ', 'Прыгина Н.Ю.', '____________________________'],
                  ['Мжельская Е.Л.', '____________________________']
                ], cell_style: {border_color: 'ffffff', padding: 0}, width: pdf.bounds.width
    end

    a_out_of_competition = []
    a_special_rights = []
    a_organization = []
    a_contest = []

   applications.for_rating.each do |a|
      if a.out_of_competition
        a_out_of_competition << a
      else
        if a.special_rights
          a_special_rights << a
        elsif a.competitive_group_target_item
          a_organization << a
        else
          a_contest << a
        end
      end
    end

    pdf.font_size = 8

    field_payment = applications.first.is_payed? ? 'paid' : 'budget'
    field_form = case applications.first.education_form_id
                 when 11 then 'o'
                 when 12 then 'oz'
                 when 10 then 'z'
                 end

    total_places = item.send("number_#{field_payment}_#{field_form}")
    total_places += item.send("number_quota_#{field_form}")
    group.target_organizations.each do |org|
      org.items.where(direction_id: item.direction_id, education_level_id: item.education_type_id).each do |i|
        total_places += i.send("number_target_#{field_form}")
      end
    end

    remaining_places = total_places

# Без вступительных испытаний.
    if a_out_of_competition.any?
      column_widths = {
        0 => 30,
        1 => 60,
        2 => 170
      }

      pdf.text 'Список поступающих без вступительных испытаний', size: 14
      data = [['', 'Рег. номер', 'Поступающий', 'Основание', 'Решение комиссии']]
      a_out_of_competition.each_with_index do |a, i|
        data << [i + 1, a.number, a.entrant.full_name, a.benefits.first.temp_text, 'допустить']
      end

      pdf.table data, width: pdf.bounds.width, header: true, column_widths: column_widths
      pdf.move_down 40

      remaining_places -= a_out_of_competition.size
    end

    exam_names = group.test_items.order(:entrance_test_priority).collect do |t|
      t.exam.name
    end
    column_widths = {
      0 => 30,
      1 => 60,
      2 => 170,
      (3 + exam_names.size) => 34,
      (3 + exam_names.size + 1) => 70
    }
    exam_names.each_with_index do |name, i|
      # Название предмета состоит из одного слова.
      if 1 == name.split(' ').size
        column_widths[3 + i] = pdf.width_of(name) + 10
      end
    end

# Квота.
    if a_special_rights.any?
      pdf.text 'Список поступающих по квоте приема лиц, имеющих особое право',
               size: 14

      pdf.text "Доступное количество мест — #{group.items.first.number_quota_o}",
               style: :bold, size: 10

      # data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Инд. достижения' << 'Сумма' << 'Решение комиссии').flatten]
      data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Сумма' << 'Решение комиссии').flatten]
      a_special_rights.each_with_index do |a, i|
        # data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
        data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
      end

      pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
      pdf.move_down 40

      #remaining_places -= (a_special_rights.size > group.items.first.number_quota_o ? group.items.first.number_quota_o : a_special_rights.size)
      remaining_places -= group.items.first.number_quota_o
    end

    if a_organization.any?
      pdf.text 'Список поступающих по квоте целевого приема', size: 14

      a_organization.group_by { |a| a.competitive_group_target_item }.each do |target_item, appls|
        pdf.text "Договор № #{target_item.target_organization.contract_number} от #{l target_item.target_organization.contract_date}, #{target_item.target_organization.name}", size: 12
        pdf.text "Доступное количество мест — #{target_item.number_target_o}",
                 style: :bold, size: 10

        # data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Инд. достижения' << 'Сумма' << 'Решение комиссии').flatten]
        data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Сумма' << 'Решение комиссии').flatten]
        appls.each_with_index do |a, i|
          # data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
          data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
        end

        pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
        pdf.move_down 40

        #remaining_places -= (appls.size > target_item.number_target_o ? target_item.number_target_o : appls.size)
        remaining_places -= target_item.number_target_o
      end
    end

# Общий конкурс.
    if a_contest.any?
      pdf.text 'Список поступающих по общему конкурсу',
               size: 14

      pdf.text "Доступное количество мест — #{remaining_places}",
               style: :bold, size: 10

      # data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Инд. достижения' << 'Сумма' << 'Решение комиссии').flatten]
      data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Сумма' << 'Решение комиссии').flatten]
      a_contest.sort_by { |a| [a.pass_min_score, a.total_score] }.reverse.each_with_index do |a, i|
        # data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map{|e| e ? e.score : ''} + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
        data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map{|e| e ? e.score : ''} + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
      end

      pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
    end

  end
end



# exams = item.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam.name }
#
# data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]
# exams.each {|e|  data.first << e}
# data.first << 'Условия участия в конкурсе'
# data.first << 'Решение комиссии'
#
# appls = item.applications.for_rating
# appls.sort { |a, b| a.number <=> b.number }.each_with_index do |ap, index|
#   data << ["#{index+1}", ap.number, ap.entrant.full_name]
#   ap.abitexams.collect{ |x| x ? x.score : '' }.each{ |x| data.last << x }
#
#   benefit = ap.benefits.first
#   if benefit && (benefit.benefit_kind.out_of_competition? || benefit.benefit_kind.special_rights?)
#     data.last << benefit.benefit_kind.short_name
#   else
#     if ap.competitive_group_target_item
#       data.last << 'Квота целевого приема'
#     else
#       data.last << 'По конкурсу'
#     end
#   end
#
#   if benefit && benefit.benefit_kind.out_of_competition?
#     data.last << 'допустить'
#   else
#     if 0 != ap.pass_min_score
#       data.last << 'допустить'
#     else
#       data.last << 'не допустить'
#     end
#   end
# end
#
# pdf.font_size 8 do
#   column_widths = {
#     0 => 30,
#     1 => 60,
#     2 => 170
#   }
#
#   pdf.table data, width: pdf.bounds.width, column_widths: column_widths
# end
