prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :landscape do |pdf|

  render 'pdf/font', pdf: pdf
  pdf.font_size 11 do

    pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
    pdf.move_down 4
    pdf.text 'о зачислении', style: :bold, align: :center
    pdf.table [['№ __________________', 'от «____» ______________ 2015 г.']
              ], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
      column(0).width = 600
    end
    pdf.move_down 2
    pdf.text "#{@item.direction.new_code} «#{@item.direction.name}»", style: :bold
    pdf.text "#{@applications.first.education_form_name} форма обучения, #{@applications.first.budget_name}", style: :bold

    pdf.font_size 10 do
      pdf.table [
                    ['Председатель приемной комиссии', 'Антипов К.В.', '____________________________'],
                    ['Зам. председателя приемной комиссии', 'Маркелова Т.В.', '____________________________'],
                    ['Зам. председателя по приему в аспирантуру', 'Назаров В.Г.', '____________________________'],
                    ['Зам. председателя по учету индивидуальных достижений', 'Рачинский Д.В.', '____________________________'],
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

    exams = @item.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam.name }
    data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]
    exams.each {|e|  data.first << e}
    data.first << 'Инд. достижения'
    data.first << 'Сумма баллов'
    if @applications.first.is_payed
      data.first << 'Договор' #<< 'Согласие на зачислении'
    else
      data.first << 'Оригинал документа об образовании'
      data.first << 'Категория зачисления'
    end
    data.first << 'Решение комиссии'



    # a_out_of_competition = []
    # a_special_rights = []
    # a_organization = []
    # a_contest_enrolled = []
    # a_contest = []
    # @applications.each do |a|
    #   if a.out_of_competition
    #     a_out_of_competition << a
    #   else
    #     if 0 != a.pass_min_score
    #       if a.special_rights
    #         a_special_rights << a
    #       elsif a.competitive_group_target_item
    #         a_organization << a
    #       else
    #         if a.order && a.order.signed?
    #           a_contest_enrolled << a
    #         else
    #           a_contest << a
    #         end
    #       end
    #     end
    #   end
    # end

    field_payment = @applications.first.is_payed ? 'paid' : 'budget'
    field_form = case @applications.first.education_form_id
                   when 11 then 'o'
                   when 12 then 'oz'
                   when 10 then 'z'
                 end

    total_places = @item.send("number_#{field_payment}_#{field_form}")
    total_places += @item.send("number_quota_#{field_form}")
    @item.competitive_group.target_organizations.each do |org|
      org.items.where(direction_id: @item.direction_id, education_level_id: @item.education_type_id).each do |i|
        total_places += i.send("number_target_#{field_form}")
      end
    end

    # remaining_places = total_places
    # remaining_places -= a_out_of_competition.size
    # remaining_places -= (a_special_rights.size > @item.number_quota_o ? @item.number_quota_o : a_special_rights.size)
    # a_organization.group_by { |a| a.competitive_group_target_item }.each do |target_item, appls|
    #   remaining_places -= (appls.size > target_item.number_target_o ? target_item.number_target_o : appls.size)
    # end
    #
    # to_enroll = remaining_places
    # last_found = false
    # prev_score = 0

    if @applications.first.out_of_competition
      @applications.each_with_index do |ap, ind|
        data << ["#{ind+1}", ap.number, ap.entrant.full_name]
        ap.abitexams.collect{|x| x.score }.each{ |x| data.last << '-' }
        data.last << '-'
        data.last << 0
        data.last << (ap.original? ? 'да' : 'нет')
        data.last << 'без вступительных испытаний'
        data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
      end

    elsif @applications.first.competitive_group_target_item
      @applications.sort_by(&Entrance::Application.sort_applications_for_sort_by).reverse.each_with_index do |ap, ind|
        data << ["#{ind+1}", ap.number, ap.entrant.full_name]
        ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
        data.last << ap.abitachievements
        data.last << ap.abitpoints
        data.last << (ap.original? ? 'да' : 'нет')
        data.last << "квота целевого приема, договор № #{ap.competitive_group_target_item.target_organization.contract_number} от #{l ap.competitive_group_target_item.target_organization.contract_date}, #{ap.competitive_group_target_item.target_organization.name}"
        data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
      end

    elsif @applications.first.special_rights
      @applications.sort_by(&Entrance::Application.sort_applications_for_sort_by).reverse.each_with_index do |ap, ind|
        data << ["#{ind+1}", ap.number, ap.entrant.full_name]
        ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
        data.last << ap.abitachievements
        data.last << ap.abitpoints
        data.last << (ap.original? ? 'да' : 'нет')
        data.last << 'квота приема по особым правам'
        data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
      end

    else

      i = 0
      @applications.sort_by(&Entrance::Application.sort_applications_for_sort_by).reverse.each do |ap|
        # if to_enroll > 0
          # Есть места — зачисляем при наличии оригинала
        if ap.is_payed
          if ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant)
            data << ["#{i+1}", ap.number, ap.entrant.full_name]
            ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            data.last << ap.abitachievements
            data.last <<  ap.abitpoints
            data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
            data.last << 'зачислить'
            i += 1
          end
        else
          if ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant)
            data << ["#{i+1}", ap.number, ap.entrant.full_name]
            ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            data.last << ap.abitachievements
            data.last << ap.abitpoints
            if ap.is_payed
              data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
            else
              data.last << (ap.original? ? 'да' : 'нет')
              if ap.campaign_id == 52015
                data.last << 'гослиния'
              else
                data.last << 'по конкурсу'
              end
            end
            data.last << 'зачислить'
            i += 1
          # else
          #   data << ["#{i+1}", ap.number, ap.entrant.full_name]
          #   ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
          #   data.last << ap.abitachievements
          #   data.last << ap.abitpoints
          #   if @item.payed?
          #     data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
          #   else
          #     data.last << (ap.original? ? 'да' : 'нет')
          #   end
          #   data.last << 'по конкурсу'
          #   data.last << 'не зачислить'
          #   i += 1
          end
        end
      end

      @applications.sort_by(&Entrance::Application.sort_applications_for_sort_by).reverse.each do |ap|
        # if to_enroll > 0
          # Есть места — зачисляем при наличии оригинала
        if !ap.is_payed
          # if ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant)
            # data << ["#{i+1}", ap.number, ap.entrant.full_name]
            # ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            # data.last << ap.abitachievements
            # data.last <<  ap.abitpoints
            # data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
            # data.last << 'зачислить'
            # i += 1
          # end
        # else
          if ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant)
            # data << ["#{i+1}", ap.number, ap.entrant.full_name]
            # ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            # data.last << ap.abitachievements
            # data.last << ap.abitpoints
            # if ap.is_payed
            #   data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
            # else
            #   data.last << (ap.original? ? 'да' : 'нет')
            #   if ap.campaign_id == 52015
            #     data.last << 'гослиния'
            #   else
            #     data.last << 'по конкурсу'
            #   end
            # end
            # data.last << 'зачислить'
            # i += 1
          else
            data << ["#{i+1}", ap.number, ap.entrant.full_name]
            ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            data.last << ap.abitachievements
            data.last << ap.abitpoints
            # if @item.payed?
            #   data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
            # else
              data.last << (ap.original? ? 'да' : 'нет')
            # end
            data.last << 'по конкурсу'
            data.last << 'не зачислить'
            i += 1
          end
        end

        #   success = true
        #   to_enroll -= 1
        #   prev_score = ap.total_score
        # elsif 0 == to_enroll && !last_found
        #   if prev_score == ap.total_score
        #     success = true
        #
        #     if ap.original?
        #       data << ["#{index+1}", ap.number, ap.entrant.full_name]
        #       ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
        #       data.last << ap.abitachievements
        #       data.last << ap.abitpoints
        #       if @item.payed?
        #         data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
        #       else
        #         data.last << (ap.original? ? 'да' : 'нет')
        #       end
        #       data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
        #     else
        #       data << ["#{index+1}", ap.number, ap.entrant.full_name]
        #       ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
        #       data.last << ap.abitachievements
        #       data.last << ap.abitpoints
        #       if @item.payed?
        #         data.last << (ap.contract ? "№ #{ap.contract.number}" : '') #<< (ap.agree? ? 'да' : 'нет')
        #       else
        #         data.last << (ap.original? ? 'да' : 'нет')
        #       end
        #       data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
        #     end
        #   end
        # end
      end
    end

    # @item.applications.actual.sort(&Entrance::Application.sort_applications).each_with_index do |ap, index|
    #   data << ["#{index+1}", ap.number, ap.entrant.full_name]
    #   ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
    #   data.last << ap.abitpoints
    #   if @item.payed?
    #     data.last << (ap.contract ? "№ #{ap.contract.number}" : '') << (ap.agree? ? 'да' : 'нет')
    #   else
    #     data.last << (ap.original? ? 'да' : 'нет')
    #   end
    #   data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
    # end

    pdf.move_down 8
    pdf.text 'на своем заседании рассмотрели список поступающих и постановили:'
    pdf.font_size 8 do
      pdf.move_down 5
      column_widths = {
          0 => 30,
          1 => 60,
          2 => 140,
          (2 + exams.size) => 40,
          (3 + exams.size) => 30,
          (4 + exams.size) => 70,
          (5 + exams.size) => 70,
          (7 + exams.size) => 60
      }
      exams.each_with_index do |name, i|
        # Название предмета состоит из одного слова.
        if 1 == name.split(' ').size
          column_widths[3 + i] = pdf.width_of(name) + 10
        end
      end
      # pdf.table data, width: pdf.bounds.width, column_widths: column_widths
      pdf.table data, column_widths: column_widths
    end
  end
end
