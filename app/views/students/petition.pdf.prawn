prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Справка-ходатайство для #{@student.person.full_name(:rp)}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|

  pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width/3 do
      render 'pdf/header', pdf: pdf, title: ''
      pdf.move_down 5
      pdf.font_size 10 do
        pdf.text '127550, Москва, Прянишникова, 2а', align: :center
        pdf.text 'тел.: (499) 976-39-73', align: :center
        pdf.text 'факс: (499) 976-06-35', align: :center
        pdf.text "№ <u>#{@petition.number}</u>", align: :center, inline_format: true
        pdf.text (l Date.today, format: '«%d» <u>%B</u> %Y г.'), align: :center, inline_format: true
      end
  end

  pdf.bounding_box [pdf.bounds.left +  pdf.bounds.width/3, pdf.bounds.top], width: pdf.bounds.width/1.5 do
    pdf.font_size 16 do
      pdf.text 'СПРАВКА-ХОДАТАЙСТВО', style: :bold
    end

  institute = @student.group.speciality.faculty.name.split
  institute[0]+='а'

    pdf.move_down 5
    pdf.font_size 12 do
      pdf.text "<u>#{@student.person.full_name}</u>", inline_format: true
      pdf.text "<strong>действительно является студентом(кой) <u>#{@student.group.course}</u> курса, <u>#{institute.join(' ')}</u>,</strong>", inline_format: true
      pdf.move_down 5
      pdf.text '<strong>Московского государственного университета печати имени Ивана Федорова</strong>', inline_format: true
      pdf.move_down 5
      order = @student.orders.template_student.last
      pdf.text "Приказ № <u>#{order.number}</u> от <u>#{order.signing_date.strftime('%d.%m.%Y') if order.signing_date}</u>, ", inline_format: true
      pdf.move_down 5
      pdf.text "в Москве на учебе с <u>#{l  Date.strptime(params[:start_date], '%d.%m.%Y'), format: '%d %B %Y г.'}</u> по <u>#{l  Date.strptime(params[:end_date], '%d.%m.%Y'), format: '%d %B %Y г.'}</u>", inline_format: true
      pdf.move_down 5
      pdf.text "Институт ходатайствует о регистрации до <u>#{l  Date.strptime(params[:end_date], '%d.%m.%Y'), format: '%d %B %Y г.'}</u>", inline_format: true
      pdf.move_down 5
        if @student.person.student_hostel_temp == 2
          pdf.text 'Выдана для передоставления в <strong>Отделение ОУФМС России по г. Москве по району «Восточное Дегунино».</strong>', inline_format: true
        elsif @student.person.student_hostel_temp == 3
          pdf.text 'Выдана для передоставления в <strong>Отделение УФМС России по г. Москве по району «Коптево».</strong>', inline_format: true
        end
      pdf.move_down 5
      pdf.text 'Проректор по АХР __________(Антипов С.В.)'
      pdf.move_down 5
      role = 'dean'
      position = @student.group.speciality.faculty.positions.from_role(role).first
      pdf.text "#{position.title} #{position.department.abbreviation} __________ (#{position.user.short_name})"
    end
  end
end