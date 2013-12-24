names = []
@data.each_with_index do |d, i|
  if 0 == i
    d[0][0] = ''
  end

  names << [d[0], d[1]] unless d[0].blank? || d[1].blank?
end

prawn_document size: :A4, page_layout: :portrait do |pdf|
  names.each_with_index do |name, index|
    render 'pdf/header', pdf: pdf, title: "ЗАПРОС № #{index + 1}", base_size: 9
    pdf.move_up 15
    pdf.font_size 11
    pdf.text 'в наркологический диспансер по месту жительства или временной регистрации.', align: :center, style: :bold
    pdf.move_down 12

    pdf.font_size 10
    pdf.text 'Просим вас провести освидетельствование работника'
    pdf.text 'Ф.И.О. (полностью) _____________________________________________________________________________________________________________'
    pdf.text 'должность  ______________________________________________________________________________________________________________________'
    pdf.text 'в целях прохождения периодического медицинского осмотра в соответствии с приказом Минздравсоцразвития РФ от 12.04.2011 г. № 302н, для допуска к работе. '
    pdf.text 'Дата __________________'

    pdf.move_down 10

    pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold
    pdf.move_down 40

    pdf.stroke_horizontal_rule
    pdf.move_down 10

    render 'pdf/header', pdf: pdf, title: "ЗАПРОС № #{index + 1}", base_size: 9
    pdf.move_up 15
    pdf.font_size 11
    pdf.text 'в психоневрологический диспансер по месту жительства или временной регистрации.', align: :center, style: :bold
    pdf.move_down 14

    pdf.font_size 10
    pdf.text 'Просим вас провести освидетельствование работника'
    pdf.text 'Ф.И.О. (полностью) _____________________________________________________________________________________________________________'
    pdf.text 'должность  ______________________________________________________________________________________________________________________'
    pdf.text 'в целях прохождения периодического медицинского осмотра в соответствии с приказом Минздравсоцразвития РФ от 12.04.2011 г. № 302н, для допуска к работе. '
    pdf.text 'Дата __________________'

    pdf.move_down 10

    pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold
    pdf.move_down 40

    pdf.stroke_horizontal_rule
    pdf.move_down 10

    render 'pdf/header', pdf: pdf, title: "ЗАПРОС № #{index + 1}", base_size: 9
    pdf.move_up 15
    pdf.font_size 11
    pdf.text 'в кожно-венерологический диспансер по месту жительства или временной регистрации.', align: :center, style: :bold
    pdf.move_down 14

    pdf.font_size 10
    pdf.text 'Просим вас провести освидетельствование работника'
    pdf.text 'Ф.И.О. (полностью) _____________________________________________________________________________________________________________'
    pdf.text 'должность  ______________________________________________________________________________________________________________________'
    pdf.text 'в целях прохождения периодического медицинского осмотра в соответствии с приказом Минздравсоцразвития РФ от 12.04.2011 г. № 302н, для допуска к работе. '
    pdf.text 'Дата __________________'

    pdf.move_down 10

    pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold

    n = name[0].squish
    d = Unicode::downcase(name[1].squish)

    [
        [93, 602, 446, 10],
        [93, 345, 446, 10],
        [93, 88, 446, 10]
    ].each do |x, y, w, h|
      #pdf.bounding_box [x, y], width: w, height: h do
      #  pdf.text n
      #  pdf.stroke_bounds
      #end
      #pdf.bounding_box [x - 37, y - 13], width: w + 37, height: h do
      #  pdf.text d
      #  pdf.stroke_bounds
      #end

      pdf.text_box n, at: [x, y], width: w, height: h, overflow: :shrink_to_fit
      pdf.text_box d, at: [x - 37, y - 13], width: w + 37, height: h, overflow: :shrink_to_fit
    end

    pdf.start_new_page
      pdf.font 'PT', size: 12, style: :bold, align: :center do
        render 'pdf/header', pdf: pdf, title: 'НАПРАВЛЕНИЕ НА ПЕРИОДИЧЕСКИЙ МЕДИЦИНСКИЙ ОСМОТР (ОБСЛЕДОВАНИЕ)', base_size: 9
      end

      pdf.font_size 10
      pdf.move_down 5
      pdf.text 'Направляется в ГБУЗ «КДЦ №6» ДЗ г. Москвы
      pdf.text '1. Ф.И.О. _____________________________________________________________________________________________________________'
      pdf.text '2. Дата рождения'
      pdf.text '3. Поступающий на работу/работающий (нужное подчеркнуть)'
      pdf.text '4. Цех, участок:'
      pdf.text '5. Вид работы, в которой работник освидетельствуется'
      pdf.text '6. Стаж работы в том виде работы, в котором работник освидетельствуется'
      pdf.text '7. Предшествующие профессии (работы), должность и стаж работы в них'
      pdf.text '8. В редные и (или) опасные вещества и производственные факторы:'
      pdf.text '8.1 Химические факторы'
      pdf.text '8.2 Физические факторы'
      pdf.text '8.3 Биологические факторы'
      pdf.text '8.4 тяжесть труда (физические перегрузки)'
      pdf.text '9. Профессия (работа)'

       pdf.move_down 10

      pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold







    pdf.start_new_page
  end
end