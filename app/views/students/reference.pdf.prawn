prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|
   pdf.font_families.update(
     'PT'=> {
        bold:  "#{Rails.root.join('app', 'assets', 'fonts', 'PTF75F.ttf')}",
        italic: "#{Rails.root.join('app', 'assets', 'fonts', 'PTF56F.ttf')}",
        normal:  "#{Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf') }"})
  reference = 1
  pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 100], width: pdf.bounds.width*7/19 do
     pdf.font 'PT', size: 10, style: :bold, align: :center do
       pdf.text  'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
     end
     pdf.move_down 30
     pdf.font 'PT', size: 8, align: :center do
       pdf.text 'ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ', align: :center
       pdf.move_down 5
       pdf.text 'ВЫСШЕГО ПРОФЕССИОНАЛЬНОГО  ОБРАЗОВАНИЯ', align: :center
     end
     pdf.move_down 15
     pdf.indent (pdf.bounds.width*7/38 + 30) do
      pdf.image "#{Rails.root}/app/assets/images/mgup.jpg", scale: 0.3
     end
     pdf.move_down 50
     pdf.font 'PT', size: 12, style: :bold, align: :center do
      pdf.text 'МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА', align: :center
      pdf.move_down 25
      pdf.text '_'*(pdf.bounds.width*7/38), align: :center
     end
     pdf.move_down 35
     pdf.indent 15 do
       pdf.font 'PT', size: 12 do
        pdf.text '127550, Москва,'
        pdf.text 'Ул. Прянишникова, 2а'
        pdf.text ' Тел.: (499) 976-39-73'
        pdf.text ' Факс: (495) 976-06-35'
       end
     end
  end
  pdf.bounding_box [pdf.bounds.left + pdf.bounds.width*8/19, pdf.bounds.top - 100], width: pdf.bounds.width*11/19 do
    pdf.font 'PT', size: 12 do
      pdf.text "СПРАВКА № #{reference}", align: :center
      pdf.move_down 15
      pdf.text 'Выдана'
      pdf.move_down 15
      pdf.text "<strong><u>#{@student.person.last_name_dp} #{@student.person.first_name_dp} #{@student.person.patronym_dp}</u></strong>", inline_format: true, align: :center
      pdf.move_down 15
      pdf.text "о том, что #{@student.sex} действительно является студентом <strong>#{@student.group.course}</strong> курса <strong>#{@student.group.support}</strong> формы обучения", inline_format: true
      institute = @student.group.speciality.faculty.name.split
      institute[0]+='а'
      pdf.text "<u>#{institute.join(' ')}</u>", inline_format: true
      pdf.text "в Московском государственном университете печати имени Ивана Федорова на #{@student.budget? ? 'бюджетной' : 'внебюджетной'} основе обучения"
      pdf.move_down 15
      @student.orders.each do |order|
        pdf.text "Приказ номер #{order.number} «#{order.name}» от #{order.signing_date.strftime("%d.%m.%Y")}"
      end
      pdf.move_down 5
      pdf.text "Нормативный срок обучения: с 01.09.#{@student.admission_year} по 30.06.#{@student.study_time.to_i + @student.admission_year.to_i}"
      pdf.move_down 10
            pdf.text '_'*(pdf.bounds.width*8/39), align: :center
      pdf.move_down 10
      pdf.text 'Выдана для предоставления'
      pdf.text "<strong><u>по месту требования</u></strong>", inline_format: true
      pdf.move_down 11
                  pdf.text '_'*(pdf.bounds.width*8/39), align: :center
      pdf.move_down 15
      month = case Date.today.strftime("%m")
       when '01' then 'января'
       when '02' then 'февраля'
       when '03' then 'марта'
       when '04' then 'апреля'
       when '05' then 'мая'
       when '06' then 'июня'
       when '07' then 'июля'
       when '08' then 'августа'
       when '09' then 'сентября'
       when '10' then 'октября'
       when '11' then 'ноября'
       when '12' then 'декабря'
      end
      pdf.text "«#{Date.today.strftime("%d")}» #{month} #{Date.today.strftime("%Y")}"
    end
    director = case @student.group.speciality.faculty.id
           when 2 then 'Винокур А. И.'
           when 3 then 'Винокур А. И.'
           when 4 then 'Столяров А. А.'
           when 5 then 'Столяров А. А.'
           when 6 then 'Горлов С. Ю.'
           when 7 then 'Корытов О. В.'
          end
    pdf.move_down 15
    data = [['Проректор', ''], ["Директор #{@student.group.speciality.faculty.abbreviation}", "#{director}"]]

    pdf.font 'PT', size: 13 do
      pdf.table data, header: true, width: 295, cell_style: { padding: 7, border_color: "d3d3d3" }, column_widths: [130, 165] do
        column(1).style align: :right
      end
    end
  end
end