prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Справка-ходатайство для #{@student.person.full_name(:rp)}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|

  pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], width: pdf.bounds.width/3 do
      render 'pdf/header', pdf: pdf, title: ''
      pdf.move_down 15
      pdf.font_size 10 do
        pdf.text '127550, Москва, Прянишникова, 2а'
        pdf.text 'тел.: (499) 976-39-73'
        pdf.text 'факс: (499) 976-06-35'
        pdf.text '№ ______'
        pdf.text (l Date.today, format: '«%d» %M %Y г.')
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
      pdf.text "действительно является студентом(кой) <u>#{@student.group.course}</u> курса <u>#{institute.join(' ')}</u>,", inline_format: true
      pdf.move_down 5
      pdf.text '<strong>Московского государственного университета печати имени Ивана Федорова</strong>', inline_format: true
      pdf.move_down 5
      @student.orders.each do |order|
        if order == @student.orders.last
          pdf.text "Приказ № <u>#{order.number}</u> от <u>#{order.signing_date.strftime('%d.%m.%Y') if order.signing_date}</u>, ", inline_format: true
        end
      end
      pdf.move_down 5
      pdf.text 'в Москве на учебе с start_date по end_date .'
      pdf.move_down 5
      pdf.text 'Институт ходатайствует о регистрации до end_date.'
      pdf.move_down 5
        if @student.person.student_hostel_temp == 2
          pdf.text 'Выдана для передоставления в Отделение ОУФМС России по г. Москве по району «Восточное Дегунино»'
        elsif @student.person.student_hostel_temp == 3
          pdf.text 'Выдана для передоставления в Отделение УФМС России по г. Москве по району «Коптево»'
        end
      pdf.move_down 25
      data = []
      positions.each do |p|
        title = Unicode::capitalize(p.title)
        if p.role.name == 'pro-rector-study'
          data << [
              title, p.user.short_name]
        else
          data << [
              "#{title} #{p.department.abbreviation}", p.user.short_name]
        end
      end
    end
  end

 end