prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :landscape do |pdf|

  render 'pdf/font', pdf: pdf
  pdf.font_size 11 do

    pdf.text 'ПРОТОКОЛ ЗАСЕДАНИЯ ПРИЕМНОЙ КОМИССИИ', style: :bold, align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', style: :bold, align: :center
    pdf.move_down 4
    pdf.text 'о зачислении', style: :bold, align: :center
    pdf.table [['№ __________________', 'от «____» ______________ 2014 г.']
              ], cell_style: {border_color: 'ffffff'}, width: pdf.bounds.width do
      column(0).width = 600
    end
    pdf.move_down 2
    pdf.text "#{@item.direction.new_code} «#{@item.direction.name}»", style: :bold
    pdf.text "#{@item.form_name} форма обучения, #{@item.budget_name}", style: :bold

    pdf.font_size 10 do
      pdf.table [
                    ['Председатель приемной комиссии', 'Антипов К.В.', '____________________________'],
                    ['Зам. председателя приемной комиссии', 'Маркелова Т.В.', '____________________________'],
                    ['Зам. председателя по приему в аспирантуру', 'Назаров В.Г.', '____________________________'],
                    ['Ответственный секретарь', 'Хохлогорская Е.Л.', '____________________________'],
                    ['Заместитель ответственного секретаря по бюджетному приему', 'Боцман Ю.Ю.', '____________________________'],
                    ['Заместитель ответственного секретаря по приему в аспирантуру', 'Ситникова Т.А.', '____________________________'],
                    ['Заместитель ответственного секретаря по проведению вступительных испытаний', 'Алиева Д.В.', '____________________________'],
                    ['Заместитель ответственного секретаря по приему иностранных граждан', 'Иванова И.А.', '____________________________'],
                    ['Заместитель ответственного секретаря', 'Саркисова Е.Ю.', '____________________________']
                ], cell_style: {border_color: 'ffffff', padding: [1, 0]}, width: pdf.bounds.width do
        column(0).width = 510
      end
    end

    pdf.move_down 8
    pdf.text 'Члены приемной комиссии'

    pdf.font_size 10 do
      pdf.table [
                    ['Корытов О.В.', '____________________________', ' ', 'Горлов С.Ю.', '____________________________', ' ', 'Винокур А.И.', '____________________________'],
                    ['Столяров А.А.', '____________________________', ' ', 'Кулаков В.В.', '____________________________', ' ', 'Сидорова Н.В.', '____________________________'],
                    ['Миронова Г.В.', '____________________________', ' ', 'Перевалова Е.В.', '____________________________', ' ', 'Дмитриев Я.В.', '____________________________'],
                    ['Гордеева Е.Е.', '____________________________', ' ', 'Шляга В.С.', '____________________________', ' ', 'Галицкий Д.В.', '____________________________'],
                    ['Голева О.П.', '____________________________', ' ', 'Толутанова Ю.Н.', '____________________________', ' ', 'Токмаков Б.В.', '____________________________'],
                    ['Яковлев А.В.', '____________________________', ' ', 'Яковлев Р.В.', '____________________________', ' ', 'Самоделова Е.В.', '____________________________']
                ], cell_style: {border_color: 'ffffff', padding: 0}, width: pdf.bounds.width
    end

    exams = @item.competitive_group.test_items.order(:entrance_test_priority).collect{ |x| x.exam.name }
    data = [['№ п/п', 'Рег. номер', 'ФИО абитуриента']]
    exams.each {|e|  data.first << e}
    data.first << 'Сумма баллов'
    if @item.payed?
      data.first << 'Договор' << 'Согласие на зачислении'
    else
      data.first << 'Оригинал документа об образовании'
    end
    data.first << 'Решение комиссии'



    a_out_of_competition = []
    a_special_rights = []
    a_organization = []
    a_contest_enrolled = []
    a_contest = []
    @item.applications.for_rating.each do |a|
      if a.out_of_competition
        a_out_of_competition << a
      else
        if 0 != a.pass_min_score
          if a.special_rights
            a_special_rights << a
          elsif a.competitive_group_target_item
            a_organization << a
          else
            if a.order && a.order.signed?
              a_contest_enrolled << a
            else
              a_contest << a
            end
          end
        end
      end
    end


    a_contest.sort(&Entrance::Application.sort_applications).each_with_index do |ap, index|
      if to_enroll > 0
        # Есть места — зачисляем при наличии оригинала
        if ap.original?
            data << ["#{index+1}", ap.number, ap.entrant.full_name]
            ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            data.last << ap.abitpoints
            if @item.payed?
              data.last << (ap.contract ? "№ #{ap.contract.number}" : '') << (ap.agree? ? 'да' : 'нет')
            else
              data.last << (ap.original? ? 'да' : 'нет')
            end
            data.last << 'зачислить'
        else
          data << ["#{index+1}", ap.number, ap.entrant.full_name]
          ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
          data.last << ap.abitpoints
          if @item.payed?
            data.last << (ap.contract ? "№ #{ap.contract.number}" : '') << (ap.agree? ? 'да' : 'нет')
          else
            data.last << (ap.original? ? 'да' : 'нет')
          end
          data.last << 'не зачислить'
        end
      elsif 0 == to_enroll && !last_found
        if prev_score == a.total_score
          if a.original?
            data << ["#{index+1}", ap.number, ap.entrant.full_name]
            ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            data.last << ap.abitpoints
            if @item.payed?
              data.last << (ap.contract ? "№ #{ap.contract.number}" : '') << (ap.agree? ? 'да' : 'нет')
            else
              data.last << (ap.original? ? 'да' : 'нет')
            end
            data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
          else
            data << ["#{index+1}", ap.number, ap.entrant.full_name]
            ap.abitexams.collect{|x| x.score }.each{ |x| data.last << x }
            data.last << ap.abitpoints
            if @item.payed?
              data.last << (ap.contract ? "№ #{ap.contract.number}" : '') << (ap.agree? ? 'да' : 'нет')
            else
              data.last << (ap.original? ? 'да' : 'нет')
            end
            data.last << (ap.enrolled? && (@order.students.collect{|student| student.entrant}.include? ap.entrant) ? 'зачислить' : 'не зачислить')
          end
        end
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
