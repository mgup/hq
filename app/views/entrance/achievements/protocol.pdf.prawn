prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :landscape do |pdf|

  render 'pdf/font', pdf: pdf

  # Суммирующий протокол
  pdf.font_size 11 do
    pdf.text 'СВОДНЫЙ ПРОТОКОЛ ЗАСЕДАНИЯ ПОДКОМИССИИ ПО УЧЕТУ ИНДИВИДУАЛЬНЫХ ДОСТИЖЕНИЙ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
    pdf.move_down 4
    pdf.text 'о назначении суммы баллов', style: :bold, align: :center
    pdf.table [['№ __________________', 'от «____» ______________ 2016 г.']
              ], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
      column(0).width = 600
    end
    pdf.move_down 2
    pdf.text 'Максимальная сумма баллов: 10', style: :bold

    pdf.font_size 10 do
      pdf.table [
                  ['Председатель подкомиссии', 'Антипов С.В.', '____________________________'],
                  ['Секретарь подкомиссии', 'Логинова Ю.А.', '____________________________']
                ], cell_style: {border_color: 'ffffff', padding: [1, 0]}, width: pdf.bounds.width do
        column(0).width = 510
      end
    end
    pdf.font_size 10 do
      pdf.move_down 4
      pdf.text 'Члены подкомиссии'
      pdf.table [
                  ['Корытов О.В.', '____________________________', ' ', 'Горлов С.Ю.', '____________________________'],
                  ['Винокур А.И.', '____________________________', ' ', 'Столяров А.А.', '____________________________'],
                  ['Феоктистова М.В.', '____________________________', ' ', 'Виноградов Д.В.', '____________________________'],
                  ['Миронов С.Н.', '____________________________', ' ', 'Барабанова Е.С.', '____________________________']

                ], cell_style: {border_color: 'ffffff', padding: 1}, width: pdf.bounds.width
    end

    data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]

    pdf.font_size 10 do
      pdf.text 'Список индивидуальных достижений в соответствии с Порядком учета индивидуальных достижений поступающих при приёме на обучение в МГУП имени Ивана Федорова в 2016/17 учебном году:'
    end
    pdf.move_down 15
    @campaign.achievement_types.each_with_index do |a, i|
      data.first << i+1
      pdf.font_size 10 do
        pdf.text "#{i+1} #{a.name}"
      end
    end
    data.first << 'Итоговый балл'

    entrants = @campaign.entrants.find_all {|e| e.achievements.any?}

    entrants.each_with_index do |e, ind|
      data << ["#{ind+1}", (e.packed_application ? e.packed_application.number : ''), e.full_name]
      @campaign.achievement_types.each do |a|
        achievement = e.achievements.find_all {|a| a.achievement_type == a}
        data.last << (achievement.any? ? achievement.first.score : '-')
      end
      sum = e.achievements.collect{|x| x.score }.compact.sum
      data.last << (sum > 10 ? 10 : sum)
    end

    pdf.move_down 10
    pdf.font_size 10 do
      pdf.text 'Решили:'
      pdf.text "утвердить список индивидуальных достижений поступающих и присвоить итоговые баллы. В соответствии с Порядком учета индивидуальных достижений поступающих при приёме на обучение в МГУП имени Ивана Федорова в 2016/17 учебном году поступающему может быть начислено за индивидуальные достижения не более #{@campaign.id == 22016 ? 20 : 10} баллов суммарно (итоговый балл)."
    end
    pdf.table data
  end

  # Отдельные протоколы
  @campaign.achievement_types.each do |achievement_type|
    next if achievement_type.achievements.empty?
    pdf.start_new_page
    pdf.font_size 11 do
      pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПОДКОМИССИИ ПО УЧЕТУ ИНДИВИДУАЛЬНЫХ ДОСТИЖЕНИЙ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
      pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
      pdf.move_down 4
      pdf.text 'о назначении баллов', style: :bold, align: :center
      pdf.table [['№ __________________', 'от «____» ______________ 2016 г.']
                ], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
        column(0).width = 600
      end
      pdf.move_down 2
      pdf.text "Индивидуальное достижение: #{achievement_type.name}", style: :bold
      pdf.text "Максимальный балл: #{achievement_type.max_ball}", style: :bold

      pdf.font_size 11 do
        pdf.table [
                    ['Председатель подкомиссии', 'Антипов С.В.', '____________________________'],
                    ['Секретарь подкомиссии', 'Логинова Ю.А.', '____________________________']
                    ], cell_style: {border_color: 'ffffff', padding: [1, 0]}, width: pdf.bounds.width do
          column(0).width = 422
        end
      end

      pdf.move_down 8
      pdf.text 'Члены подкомиссии'

      pdf.font_size 11 do
        pdf.table [
                    ['Корытов О.В.', '____________________________', ' ', 'Горлов С.Ю.', '____________________________'],
                    ['Винокур А.И.', '____________________________', ' ', 'Столяров А.А.', '____________________________'],
                    ['Феоктистова М.В.', '____________________________', ' ', 'Виноградов Д.В.', '____________________________'],
                    ['Миронов С.Н.', '____________________________', ' ', 'Барабанова Е.С.', '____________________________']

                  ], cell_style: {border_color: 'ffffff', padding: 1}, width: pdf.bounds.width
      end

      data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента', 'Назначенный балл']]

      achievements = achievement_type.achievements.find_all {|a| a.entrant && a.entrant.packed_application }
                       .sort_by {|a| a.entrant.full_name}

     achievements.each_with_index do |a, ind|
        data << ["#{ind+1}", a.entrant.packed_application.number, a.entrant.full_name, a.score]
     end

      pdf.move_down 15
      pdf.font_size 10 do
        pdf.text 'Решили:'
        pdf.text 'утвердить следующие баллы за рассматриваемое индивидуальное достижение.'
      end
      pdf.table data
    end
  end
end
