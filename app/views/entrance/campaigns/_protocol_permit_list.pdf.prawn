# ['14', '15'].each do |payment|
#   ['10', '11', '12'].each do |form|
['14'].each do |payment|
  ['11'].each do |form|
    applications = @campaign.applications.for_rating.rating(form, payment, direction.id.to_s)

    next if applications.empty?
    # распределяем по типу конкурса
    exam_names = {}
    exam_names_crimea = {}

    out_of_competition = []
    crimea = []
    special_rights = []
    organization = []
    contest = []

    applications.each do |a|
      out_of_competition << a if a.out_of_competition? && a.order_id.present?

      exams = a.competitive_group.test_items.order(:entrance_test_priority).map { |t| t.exam.name }
      if a.competitive_group.name.include?('Крым')
        crimea << a if a.order_id.present?
        exams.each_with_index do |name, i|
          if exam_names_crimea[i].present?
            exam_names_crimea[i] += " / #{name}" unless exam_names_crimea[i].include?(name)
          else
            exam_names_crimea[i] = name
          end
        end
      else
        if a.special_rights?
          special_rights << a if a.order_id.present?
        elsif a.competitive_group_target_item.present?
          organization << a if a.order_id.present?
        else
          contest << a
        end

        exams.each_with_index do |name, i|
          if exam_names[i].present?
            exam_names[i] += " / #{name}" unless exam_names[i].include?(name)
          else
            exam_names[i] = name
          end
        end
      end
    end
    exam_names[exam_names.size] = 'Индивидуальные достижения'
    exam_names_crimea[exam_names_crimea.size] = 'Индивидуальные достижения'
    # распределяем по типу конкурса

    # считаем места
    total_places = 0
    crimea_places = 0
    quota_places = 0
    target_places = 0

    form_m = case form
             when '10' then :z
             when '11' then :o
             when '12' then :oz
             end

    payment_m = case payment
                when '14' then :budget
                when '15' then :paid
                end

    direction.competitive_group_items.each do |gi|
      g = gi.competitive_group

      next unless @campaign.id == g.campaign_id

      total_places += gi.send("number_#{payment_m}_#{form_m}")

      if g.name.include?('Крым')
        crimea_places += gi.send("number_#{payment_m}_#{form_m}")
      end

      total_places += gi.send("number_quota_#{form_m}")
      quota_places += gi.send("number_quota_#{form_m}")


      if g.target_organizations.any?
        t = g.target_organizations.map(&:items).sum.find_all { |i| i.direction.description == direction.description }.map(&"number_target_#{form_m}".to_sym).sum
        total_places += t
        target_places += t
      end
    end
    # считаем места

    # Крым.
    if crimea.any?

      column_widths = {
        0 => 30,
        1 => 60,
        2 => 170,
        (3 + exam_names.size) => 34,
        (3 + exam_names.size + 1) => 70
      }
      exam_names.each_with_index do |name, i|
        # Название предмета состоит из одного слова.
        if 1 == name[1].split(' ').size
          column_widths[3 + i] = pdf.width_of(name[1]) + 10
        end
      end

      if false
      pdf.start_new_page if new_page
      new_page = true
      pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
      pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
      pdf.text 'о допуске к участию в конкурсе на основные конкурсные места на первом этапе зачисления', style: :bold, align: :center

      pdf.table [['№ __________________', 'от 15 июля 2016 г.']], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
        column(0).width = 600
      end
      pdf.move_down 8
      pdf.text "#{direction.new_code}, #{direction.name}"
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


      pdf.text 'Список поступающих на выделенные места (Крым)',
               size: 14

      pdf.text "Доступное количество мест — #{crimea_places}",
               style: :bold, size: 10

      end
      data = [(['', 'Рег. номер', 'Поступающий'] << exam_names_crimea.collect{|_, n| n} << 'Сумма' << 'Решение комиссии').flatten]
      crimea.each_with_index do |a, i|
        data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
        crimea_places -= 1 if a.original? && a.pass_min_score?
        total_places -= 1 if a.original? && a.pass_min_score?
      end
      total_places -= crimea_places if crimea_places > 0

      # pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
      # pdf.move_down 40

    end

    pdf.start_new_page if new_page
    new_page = true
    pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
    pdf.text 'о допуске к участию в конкурсе на основные конкурсные места на первом этапе зачисления', style: :bold, align: :center

    pdf.table [['№ __________________', 'от 29 июля 2016 г.']], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
      column(0).width = 600
    end
    pdf.move_down 8
    pdf.text "#{direction.new_code}, #{direction.name}"
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


# Без вступительных испытаний.
    if out_of_competition.any?
      column_widths = {
        0 => 30,
        1 => 60,
        2 => 170
      }

      # pdf.text 'Список поступающих без вступительных испытаний', size: 14
      data = [['', 'Рег. номер', 'Поступающий', 'Основание', 'Решение комиссии']]
      out_of_competition.each_with_index do |a, i|
        data << [i + 1, a.number, a.entrant.full_name, a.benefits.first.temp_text, (a.original? ? 'допустить' : 'не допустить')]
        total_places -= 1
      end

      # pdf.table data, width: pdf.bounds.width, header: true, column_widths: column_widths
      # pdf.move_down 40

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
      if 1 == name[1].split(' ').size
        column_widths[3 + i] = pdf.width_of(name[1]) + 10
      end
    end

# Крым.
#     if crimea.any?
#       pdf.text 'Список поступающих на выделенные места (Крым)',
#                size: 14
#
#       pdf.text "Доступное количество мест — #{crimea_places}",
#                style: :bold, size: 10
#
#       data = [(['', 'Рег. номер', 'Поступающий'] << exam_names_crimea.collect{|_, n| n} << 'Сумма' << 'Решение комиссии').flatten]
#       crimea.each_with_index do |a, i|
#         data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
#         crimea_places -= 1 if a.original? && a.pass_min_score?
#         total_places -= 1 if a.original? && a.pass_min_score?
#       end
#       total_places -= crimea_places if crimea_places > 0
#
#       pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
#       pdf.move_down 40
#
#     end

# Квота.
    if special_rights.any?
      # pdf.text 'Список поступающих по квоте приема лиц, имеющих особое право',
      #          size: 14
      #
      # pdf.text "Доступное количество мест — #{quota_places}",
      #          style: :bold, size: 10

      data = [(['', 'Рег. номер', 'Поступающий'] << exam_names.collect{|_, n| n} << 'Сумма' << 'Решение комиссии').flatten]
      special_rights.each_with_index do |a, i|
        data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
        quota_places -= 1
        total_places -= 1
      end
      total_places -= quota_places if quota_places > 0

      # pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
      # pdf.move_down 40

    end


    # Целевики.
    if organization.any?
      # pdf.text 'Список поступающих по квоте целевого приема', size: 14
      #
      organization.group_by { |a| a.competitive_group_target_item }.each do |target_item, appls|
      #   pdf.text "Договор № #{target_item.target_organization.contract_number} от #{l target_item.target_organization.contract_date}, #{target_item.target_organization.name}", size: 12
      #   pdf.text "Доступное количество мест — #{target_places}",
      #            style: :bold, size: 10

        data = [(['', 'Рег. номер', 'Поступающий'] << exam_names.collect{|_, n| n} << 'Сумма' << 'Решение комиссии').flatten]

        appls.each_with_index do |a, i|
          data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']
          target_places -= 1
          total_places -= 1
        end
        total_places -= target_places if target_places > 0

        # pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
        # pdf.move_down 40

      end
    end

# Общий конкурс.
    if contest.any?
      pdf.text 'Список поступающих по общему конкурсу',
               size: 14

      pdf.text "Доступное количество мест — #{total_places}, на первом этапе зачисления доступно — #{(total_places*0.8).ceil}",
               style: :bold, size: 10

      data = [(['', 'Рег. номер', 'Поступающий'] << exam_names.collect{|_, n| n} << 'Сумма' << 'Решение комиссии').flatten]
      contest.sort_by { |a| [a.pass_min_score, a.total_score] }.reverse.each_with_index do |a, i|
        data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map{|e| e ? e.score : ''} + [a.abitachievements] + [a.total_score + a.abitachievements] + [0 != a.pass_min_score ? 'допустить' : 'не допустить']

      end

      pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
    end

  end
end



