# prawn_document margin: [28.34645669291339, 28.34645669291339,
#                         28.34645669291339, 28.34645669291339],
#                page_size: 'A4', page_layout: :portrait do |pdf|
#   render 'pdf/font', pdf: pdf
#
#   @students.each_with_index do |_, index|
#     pdf.start_new_page if index != 0
#     pdf.image "#{Rails.root}/app/assets/images/session_call_template_1.png", at: [0,800], scale: 0.44
#     pdf.start_new_page
#     pdf.image "#{Rails.root}/app/assets/images/session_call_template_2.png", at: [0,800], scale: 0.44
#   end
# end


prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/font', pdf: pdf


  @students.each_with_index do |student, index|
    pdf.start_new_page if index > 0

    pdf.font_size 6 do
      pdf.bounding_box([320,  pdf.bounds.top], width: 200) do
        pdf.text 'УТВЕРЖДЕНА', align: :center, style: :bold
        pdf.text 'приказом Министерства образования и науки', align: :center, style: :bold
        pdf.text 'Российской Федерации', align: :center, style: :bold
        pdf.text 'от 19 декабря 2013 г. № 1368', align: :center, style: :bold

      end
    end

    pdf.font 'PTSerif', size: 11, style: :bold do
      pdf.text 'СПРАВКА-ВЫЗОВ', align: :center
      pdf.text  "от «______» ________________ 20______ г. № ________,", align: :center

      [['%d', 119], ['%B', 180], ['%y', 242]].each do |date, x|
        pdf.text_box "#{l student.proofs.last.date, format: date}", at: [x, 740], width: 100, height: 20, overflow: :shrink_to_fit, align: :center
      end

      pdf.text_box "#{student.proofs.last.id}", at: [303, 740], width: 100, height: 20, overflow: :shrink_to_fit, align: :center

      pdf.text 'дающая право на предоставление гарантий и компенсаций работникам, совмещающим работу с получением образования', align: :center
    end

    pdf.font_size 11 do
      pdf.move_down 20
pdf.text 'Работодателю _______________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.indent 50 do
          pdf.text 'полное наименование организации-работодателя/фамилия, имя, отчество', align: :center
        end
      end
      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'работодателя – физического лица', align: :center
      end

      if student.person.employer && student.person.employer != ''
        pdf.text_box "#{student.person.employer}", at: [103, 677], width: 300, height: 50, align: :center, leading: 9
      end

      pdf.text 'В соответствии со статьей ________________________________ Трудового кодекса Российской Федерации'
      pdf.font_size 7 do
        pdf.indent 152 do
          pdf.text '173/173.1/174/176 (указать нужное)'
        end
      end

      pdf.text_box '173', at: [156, 631], width: 100, height: 20, align: :center

      pdf.move_down 5
      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'фамилия, имя, отчество (в дательном падеже)', align: :center
      end

      pdf.text_box "#{student.person.full_name(:dp)},", at: [0, 602], width: 500, height: 20, align: :center, style: :bold, overflow: :shrink_to_fit

      pdf.text "допущенному к вступительным испытаниям/слушателю подготовительного отделения образовательной организации высшего образования/<u>обучающемуся</u> (подчеркнуть нужное) по", inline_format: true, align: :justify, leading: 5
      pdf.text '__________________________________________ форме обучения на _______________________________ курсе,'
      pdf.font_size 7 do
        pdf.indent 17 do
          pdf.text 'очной/очно-заочной/заочной (указать нужное)'
        end
      end

      pdf.text_box "#{study_form_name(@group.form, :rp)}", at: [45, 540], width: 100, height: 20, align: :center
      pdf.text_box "#{@group.course}", at: [315, 540], width: 100, height: 20, align: :center

      pdf.text 'предоставляются гарантии и компенсации для __________________________________________________________'
      pdf.font_size 7 do
        pdf.indent 300 do
          pdf.text 'прохождения вступительных испытаний/'
        end
      end

      pdf.text_box  "                                                                                        #{@typecall}", at:[0, 520], width: 500, height: 60, align: :center, inline_format: true, leading: 12

      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'промежуточной аттестации/государственной итоговой аттестации/итоговой аттестации/', align: :center
      end
      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'подготовки и защиты выпускной квалификационной работы и/или сдачи итоговых государственных экзаменов/', align: :center
      end
      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'завершения диссертации на соискание ученой степени кандидата наук (указать нужное)', align: :center
      end
      pdf.text 'с _____________________________________________________ по _____________________________________________________'
      pdf.font_size 7 do
        pdf.indent 90 do
          pdf.text 'число, месяц, год                                                                                                                             число, месяц, год'
        end
      end

      pdf.text_box "#{l @from, format: '%d %B %Y'}", at: [69, 424], width: 100, height: 20, align: :center
      pdf.text_box "#{l @to, format: '%d %B %Y'}", at: [336, 424], width: 100, height: 20, align: :center
      pdf.text_box "#{@days}", at: [115, 400], width: 100, height: 20, align: :center

      pdf.text "продолжительностью _______________________ #{pluralize_without_number(@days, 'календарного дня', 'календарных дней', 'календарных дней')}."
      pdf.font_size 7 do
        pdf.indent 144 do
          pdf.text '(количество)'
        end
      end

      #pdf.text "В соответствии со статьей 173 Трудового кодекса Российской Федерации #{student.person.full_name(:dp)}, обучающе#{student.person.male? ? 'муся' : 'йся'} по #{study_form_name(@group.form, :rp)} форме обучения на #{@group.course} курсе, предоставляются гарантии и компенсации для #{@typecall} с #{l @from} по #{l @to} продолжительностью #{pluralize(@days, 'календарного дня', 'календарных дней', 'календарных дней')}.", align: :justify

      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'полное наименование организации,', align: :center
      end

      pdf.text_box 'федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова»', at: [-15, 378], width: 540, height: 40, align: :center, leading: 9

      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'осуществляющей образовательную деятельность', align: :center
      end
      pdf.text 'имеет свидетельство о государственной аккредитации, выданное'
      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'наименование аккредитационного органа, выдавшего свидетельство о государственной аккредитации', align: :center
      end

      pdf.text_box 'Федеральной службой по надзору в сфере образования и науки', at: [0, 317], width: 540, height: 20, align: :center

      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'реквизиты свидетельства о государственной аккредитации', align: :center
      end

      pdf.text_box '№ 1542 от 19 марта 2012 г., серия ВВ № 001559', at: [0, 294], width: 540, height: 20, align: :center

      pdf.text 'по образовательной программе ____________________________________________________________ образования'
      pdf.font_size 7 do
        pdf.indent 150 do
          pdf.text 'основного общего/среднего общего/среднего профессионального/высшего (указать нужное)'
        end
      end

      pdf.text_box 'высшего', at: [250, 269], width: 100, height: 20, align: :center

      pdf.text "по профессии/#{@group.speciality.specialist? ? '<u>специальности</u>/направлению' : 'специальности/<u>направлению подготовки</u>'} _______________________________________________", inline_format: true
      pdf.font_size 7 do
        pdf.indent 350 do
          pdf.text 'код и наименование профессии/'
        end
      end

      pdf.text_box "#{@group.speciality.code}", at: [350, 246], width: 100, height: 20, align: :center

      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'специальности/направления подготовки (указать нужное)', align: :center
      end

      pdf.text_box "#{@group.speciality.name}", at: [0, 223], width: 500, height: 20, align: :center

      #pdf.text "Федеральное государственное бюджетное образовательное учреждении высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» имеет свидетельство о государственной аккредитации, выданное Федеральной службой по надзору в сфере образования и науки 19 марта 2012 г., № 1542 по образовательной программе высшего профессионального образования по #{@group.speciality.specialist? ? 'специальности' : 'направлению подготовки'} #{@group.speciality.full_name}.", align: :justify

      pdf.move_down 5

      pdf.text 'Первый проректор по учебной работе    __________________________       ____________________________________'
      pdf.font_size 7 do
        pdf.indent 250 do
          pdf.text 'подпись                                                                   фамилия, имя, отчество'
        end
        pdf.indent 190 do
          pdf.text 'М. П.', color: '444444'
        end
      end

      pdf.text_box 'Т. В. Маркелова', at: [375, 196], width: 100, height: 20, align: :center

      # pdf.table [['Первый проректор по учебной работе', '________________________  Маркелова Т. В.']], width: pdf.bounds.width, cell_style: { padding: 7, border_color: 'ffffff' } do
      #   column(1).style align: :right
      # end
      # pdf.font_size 7 do
      #   pdf.indent 300 do
      #     pdf.text 'М. П.'
      #   end
      # end


      pdf.move_down 15


      pdf.dash 3, space: 1
      pdf.stroke do
        pdf.move_down 4
        pdf.stroke_color '555555'
        pdf.horizontal_rule
      end

      pdf.move_down 10

      pdf.undash

      # pdf.font_size 7 do
      #   pdf.text 'Линия отрыва', align: :center
      # end

      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.text 'фамилия, имя, отчество', align: :center
      end

      pdf.font_size 9 do
        pdf.text_box "#{student.person.full_name}", at: [0, 134], width: 500, height: 20, align: :center, style: :bold, overflow: :shrink_to_fit

        pdf.text_box  '                             федеральном государственном бюджетном образовательном учреждении высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова»', at:[0, 110], width: 500, height: 60, align: :center, inline_format: true, leading: 12
        pdf.text_box "#{l @from, format: '%d %B %Y'}", at: [69, 62], width: 100, height: 20, align: :center, style: :bold
        pdf.text_box "#{l @to, format: '%d %B %Y'}", at: [336, 62], width: 100, height: 20, align: :center, style: :bold
        pdf.text_box 'Т. В. Маркелова', at: [375, 35], width: 100, height: 20, align: :center
      end
      pdf.text 'находился в __________________________________________________________________________________________________'
      pdf.font_size 7 do
        pdf.indent 220 do
          pdf.text 'полное наименование организации,'
        end
      end
      pdf.text '________________________________________________________________________________________________________________'
      pdf.font_size 7 do
          pdf.text 'осуществляющей образовательную деятельность (в предложном падеже)', align: :center
      end
      pdf.text 'с _____________________________________________________ по _____________________________________________________'
      pdf.font_size 7 do
        pdf.indent 90 do
          pdf.text 'число, месяц, год                                                                                                                             число, месяц, год'
        end
      end

      pdf.move_down 4

      pdf.text 'Первый проректор по учебной работе    __________________________       ____________________________________'
      pdf.font_size 7 do
        pdf.indent 250 do
          pdf.text 'подпись                                                                   фамилия, имя, отчество'
        end
        pdf.indent 190 do
          pdf.text 'М. П.', color: '444444'
        end
      end
    end

    # pdf.move_down 20
    # pdf.font_size 11 do
    #   pdf.text "#{student.full_name} находил#{student.person.male? ? 'ся' : 'ась'} в федеральном государственном бюджетном образовательном учреждении высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» с #{l @from} по #{l @to}.", align: :justify
    #   pdf.move_down 25
    #   pdf.table [['Первый проректор по учебной работе', '________________________  Маркелова Т. В.']], width: pdf.bounds.width, cell_style: { padding: 7, border_color: 'ffffff' } do
    #     column(1).style align: :right
    #   end
    #   pdf.font_size 7 do
    #     pdf.indent 300 do
    #       pdf.text 'М. П.'
    #     end
    #   end
    # end

  end
end
