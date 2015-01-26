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
      pdf.text "<u>#{@student.person.full_name}</u>"
      pdf.text "действительно является студентом <u>#{@student.group.course}</u> курса <u>#{institute.join(' ')}</u>,", inline_format: true
      pdf.move_down 5
      pdf.text '<strong>Московского государственного университета печати имени Ивана Федорова</strong>', inline_format: true
    end
  end



 end