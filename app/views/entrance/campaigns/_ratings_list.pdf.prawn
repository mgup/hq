# pdf.text group.name

item = group.items.first

[:not_paid].each do |payment|
  [:z_form, :oz_form, :o_form].each do |form|
    applications = item.applications.send(form).send(payment)
    next unless applications.any?
    pdf.start_new_page
    pdf.font_size = 12
    pdf.bounding_box([0, pdf.cursor], width: 510) do
      pdf.bounding_box([0, pdf.bounds.top], width: 500) do
        if applications.first.direction.master?
          pdf.text 'Конкурсные списки', style: :bold, size: 14
        else
          pdf.text 'Конкурсные списки, I этап', style: :bold, size: 14
          # pdf.text 'Конкурсные списки, II этап', style: :bold, size: 14
        end

        pdf.text "#{group.items.first.direction.new_code}, #{group.items.first.direction.name}", size: 14
        pdf.text "#{applications.first.education_form_name} форма обучения, #{applications.first.budget_name}", size: 14
        # pdf.stroke_bounds
      end

      pdf.bounding_box([500,  pdf.bounds.top], width: 250) do
        pdf.text 'УТВЕРЖДАЮ'
        pdf.text 'Председатель Приемной комиссии'
        # pdf.text 'Зам. председателя Приемной комиссии'
        pdf.text 'МГУП имени Ивана Федорова'
        pdf.move_down 20
        pdf.text '_____________________ / К. В. Антипов /'
        # pdf.text '_____________________ / Т. В. Маркелова /'

        # pdf.stroke_bounds
      end

      # pdf.stroke_bounds
    end
    pdf.move_down 100

    a_out_of_competition = []
    a_special_rights = []
    a_organization = []
    a_contest_enrolled = []
    a_contest = []

    applications.for_rating.each do |a|
      if a.out_of_competition
        a_out_of_competition << a
      else
        if 0 != a.pass_min_score
          if a.special_rights
            a_special_rights << a
          elsif a.competitive_group_target_item
            a_organization << a
          else
            if a.order && a.order.signed? && a.order.signing_date <= Date.new(2015,7,27) # TODO убрать условие
              a_contest_enrolled << a
            else
              a_contest << a
            end
          end
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
      data = [['', 'Рег. номер', 'Поступающий', 'Причина']]
      a_out_of_competition.each_with_index do |a, i|
        data << [i + 1, a.number, a.entrant.full_name, a.benefits.first.temp_text]

        #remaining_places -= 1 if (a.enrolled? && a.order.signed? && a.order.signing_date <= Date.new(2015,7,27))
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
      (4 + exam_names.size) => 50,
      (5 + exam_names.size) => 65
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

      data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Инд. достижения' << 'Сумма' << 'Оригинал').flatten]
      a_special_rights.sort(&Entrance::Application.sort_applications).each_with_index do |a, i|
        data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.abitachievements + a.total_score, (a.original? ? 'да' : 'нет')]

        # remaining_places -= 1 if (a.enrolled? && a.order.signed? && a.order.signing_date <= Date.new(2015,7,27))
      end

      pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
      pdf.move_down 40

      ##remaining_places -= (a_special_rights.size > group.items.first.number_quota_o ? group.items.first.number_quota_o : a_special_rights.size)
      remaining_places -= group.items.first.number_quota_o
    end

    if a_organization.any?
      # if a_organization[0].direction.master?
        pdf.text 'Список поступающих по квоте целевого приема', size: 14
      # end

      a_organization.group_by { |a| a.competitive_group_target_item }.each do |target_item, appls|
        # if a_organization[0].direction.master?
          pdf.text "Договор № #{target_item.target_organization.contract_number} от #{l target_item.target_organization.contract_date}, #{target_item.target_organization.name}", size: 12
          pdf.text "Доступное количество мест — #{target_item.number_target_o}",
                   style: :bold, size: 10
        # end

        data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Инд. достижения' << 'Сумма' << 'Оригинал').flatten]
        appls.sort(&Entrance::Application.sort_applications).each_with_index do |a, i|
          data << [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.abitachievements + a.total_score, (a.original? ? 'да' : 'нет')]

          # remaining_places -= 1 if (a.enrolled? && !a_organization[0].direction.master? && a.order.signed? && a.order.signing_date <= Date.new(2015,7,27))
        end

        # if a_organization[0].direction.master?
          pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
          pdf.move_down 40

          ##remaining_places -= (appls.size > target_item.number_target_o ? target_item.number_target_o : appls.size)
          remaining_places -= target_item.number_target_o
        # end
      end
    end

    if a_contest_enrolled.any?
      remaining_places -= a_contest_enrolled.size
    end

    # Общий конкурс.
    if a_contest.any?
      pdf.text 'Список поступающих по общему конкурсу',
               size: 14

      pdf.text "Вакантных мест всего — #{remaining_places}",
               style: :bold, size: 10

      unless a_contest[0].direction.master?
        pdf.text "Доступно для зачисления на первом этапе 80% вакантных мест — #{remaining_places - (remaining_places * 0.2).ceil}",
                  style: :bold, size: 10
        # pdf.text "Доступно для зачисления на втором этапе 100% вакантных мест — #{remaining_places}",
        #          style: :bold, size: 10
        #
        # pdf.text 'Прием оригиналов документов об образовании для зачисления на втором этапе завершается в 18:00 МСК 6 августа 2015 года.',
        #          style: :bold, size: 10
      end

      data = [(['', 'Рег. номер', 'Поступающий'] << exam_names << 'Инд. достижения' << 'Сумма' << 'Оригинал').flatten]

      to_enroll = remaining_places
      last_found = false
      prev_score = 0

      a_contest.sort_by(&Entrance::Application.sort_applications_for_sort_by).reverse.each_with_index do |a, i|
        d = [i + 1, a.number, a.entrant.full_name] + a.abitexams.map(&:score) + [a.abitachievements] + [a.abitachievements + a.total_score, (a.original? ? 'да' : 'нет')]

        # if to_enroll > 0
        #   to_enroll -= 1
        #   prev_score = a.total_score
        #   d << 'Рекомендован'
        # elsif 0 == to_enroll && !last_found
        #   if prev_score == a.total_score
        #     d << 'Рекомендован'
        #   else
        #     last_found = true
        #     d << 'Резерв'
        #   end
        # else
        #   d << 'Резерв'
        # end

        data << d
      end

      pdf.table data, width: pdf.bounds.width, column_widths: column_widths, header: true
    end
  end
end
