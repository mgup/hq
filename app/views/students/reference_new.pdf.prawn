
# prawn_document margin: [56.6929, 56.6929,
#                         28.3465, 56.6929],
prawn_document margin: [28.34645669291339, 28.34645669291339,
                        14.34645669291339, 28.692913386],
               filename: "Справка для #{@student.person.full_name(:rp)}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/font', pdf: pdf


  count = params[:count].to_i
  count.times do |i|
    pdf.start_new_page if i > 0
    pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 10], width: pdf.bounds.width*8/19 do
      pdf.font_size 9 do
        pdf.text  'МИНОБРНАУКИ РОССИИ', align: :center, style: :bold
      end
      pdf.move_down 4
      pdf.font_size 9 do
        pdf.text 'Федеральное государственное', align: :center, style: :bold
        pdf.text 'бюджетное образовательное', align: :center, style: :bold
        pdf.text 'учреждение высшего образования', align: :center, style: :bold
        pdf.move_down 2
        pdf.text '«Московский политехнический университет»', align: :center, style: :bold
        pdf.text '(Московский Политех)', align: :center, style: :bold
      end
      pdf.text '_'*(pdf.bounds.width*4/38), align: :center

      pdf.move_down 5
      pdf.indent 5 do
        pdf.font_size 9 do
          pdf.text 'Б. Семеновская ул., д. 38, Москва, 107023.', align: :center
          pdf.text 'Тел. (495) 223-05-23, Факс (499) 785-62-24. ', align: :center
          pdf.text 'E-mail: mospolytech@mospolytech.ru', align: :center
          if count > 1
            pdf.text "<u>«#{l @reference.date, format: '%d'}» #{l @reference.date, format: '%B'} #{l @reference.date, format: '%Y'}г.</u> № <u>#{@reference.number}/#{i+1}</u>", inline_format: true, align: :center
          else
            pdf.text "<u>«#{l @reference.date, format: '%d'}» #{l @reference.date, format: '%B'} #{l @reference.date, format: '%Y'}г.</u> № <u>#{@reference.number}</u>", inline_format: true, align: :center
          end
        end
      end
    end

    pdf.bounding_box [pdf.bounds.left + pdf.bounds.width*9/19, pdf.bounds.top - 10], width: pdf.bounds.width*10/19 do

      pdf.font_size 14 do
          pdf.text'СПРАВКА', align: :center, style: :bold
      end

      birth = params[:addBirthday] ? (@student.person.birthday ? ", <u>#{l(@student.person.birthday, format: '%d %B %Y')}</u>  года рождения," : '') : ''

      institute = @student.group.speciality.faculty.name.split
      institute[0]+='а'

      tax = params[:addTax] ? " #{@student.budget? ? '<u>бюджетной</u>' : '<u>договорной</u>'} основы" : ''
      pensionniy = params[:addStrange] ? ' по основной образовательной программе ' : ''
      license = params[:addLicense] ? ', осуществляющем образовательную деятельность на основании <u>Лицензии, серия 90Л01 №0009465, выданной Федеральной службой по надзору в сфере образования и науки, регистрационный №2398 от 22 сентября 2016 г., и Свидетельства о государственной аккредитации, серия 90А01 №000241, выданного Федеральной службой по надзору в сфере образования и науки на срок по 19 марта 2018 г., регистрационный №2292 от 11 октября 2016 г</u>' : ''
      last_year = @student.last_status_order.signing_date.year
      study_year = (last_year == Study::Discipline::CURRENT_STUDY_YEAR + 1) ? (Study::Discipline::CURRENT_STUDY_YEAR + 1) : Study::Discipline::CURRENT_STUDY_YEAR
      years = @student.is_valid? ? "#{study_year}/#{study_year+1}" : (@student.last_status_order.signing_date.month > 8 ? "#{last_year}/#{last_year+1}" : "#{last_year-1}/#{last_year}")


      pdf.font_size 12 do
        pdf.move_down 20
        pdf.text "Выдана <u>#{@student.person.full_name(:dp)}</u>#{birth} о том, что #{@student.sex} #{(@student.is_valid? || @student.student_group_status == Student::STATUS_SABBATICAL) ? 'является' : (@student.person.male? ? 'являлся' : 'являлась')} обучающимся <u>#{@student.group.course}</u> курса#{tax} <u>#{study_form_name(@student.group.form, :rp)}</u> формы обучения в #{years} учебном году #{pensionniy}по #{@student.group.speciality.name_tvor} <u>#{@student.group.speciality.code}</u> — «<u>#{@student.group.speciality.name}»</u>#{' ' +institute.join(' ')} #{(@student.is_valid? || @student.student_group_status == Student::STATUS_SABBATICAL) ? 'Московского политехнического университета Высшей школы печати и медиаиндустрии' : 'Московского государственного университета печати имени Ивана Федорова'}#{license}.", inline_format: true, align: :justify, leading: 6
      end
    end
    pdf.font_size 12 do
         # в #{years} учебном году по #{@student.group.speciality.name_tvor} <u>#{@student.group.speciality.code}</u> — «<u>#{@student.group.speciality.name}»</u> в ФГБОУ ВО «Московский политехнический университет» Высшая школа печати и медиаиндустрии #{license}.", inline_format: true, align: :justify
        pdf.move_down 5

        if params[:addPeriod]
          period_text = " Нормативный срок освоения образовательной программы составляет <u>#{@student.group.study_length.round} #{@student.group.study_length > 4 ? 'лет' : 'года'}</u>: <u>с #{params[:dateIn]} по #{params[:dateOut]}</u>"
        end

        if params[:orders]
          pdf.move_down 5
          orders = Office::Order.find(params[:orders])
          if orders.length == 1
            order = orders.first
            pdf.text "<b>#{@student.person.male? ? 'Зачислен' : 'Зачислена'}</b> приказом № #{order.number} от #{order.signing_date.strftime('%d.%m.%Y') if order.signing_date}.#{period_text}", inline_format: true, leading: 6

          else
            orders.each_with_index do |order, index|
              pdf.text "#{index+1}. Приказ № #{order.number} «#{order.name if order.template}» от #{order.signing_date.strftime('%d.%m.%Y') if order.signing_date}"
            end
            pdf.move_down 5
            if params[:addPeriod]
              pdf.text period_text, inline_format: true
            end
          end
          pdf.move_down 5
        end

        if params[:addPeriod] && !params[:orders]
          pdf.text period_text, inline_format: true
        end
        pdf.move_down 5
        pdf.text 'Дана для предоставления', style: :bold
        pdf.move_down 2
        pdf.text params[:place], align: :center
        pdf.move_up 10
        pdf.text '_' * 90, align: :center

        pdf.move_down 12
        finish = @reference.date + 1.month
        # pdf.text "<b>Действительна по</b> «<u>#{l finish, format: '%d'}</u>» <u>#{l finish, format: '%B'}</u> #{l finish, format: '%Y'}г.", inline_format: true
        pdf.text "<b>Действительна по</b> «<u>31</u>» <u>августа</u> 2017г.", inline_format: true

        if params[:addMamiText]
          pdf.move_down 10
          pdf.font_size 10 do
            pdf.text 'Приказом Министерства образования и науки Российской Федерации от 21.03.2016 г. № 261 федеральное государственное бюджетное образовательное учреждение высшего образования «Московский государственный машиностроительный университет (МАМИ)» и федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» реорганизовано в форме слияния с образованием на их основе федерального государственного бюджетного образовательного учреждения высшего образования «Московский политехнический университет».', align: :justify
          end
        end

        if '1' == params[:sign]
          # data = [['Директор Высшей школы печати и медиаиндустрии', 'Антипов К. В.'],
          data = [['Начальник управления контингента образовательных программ', 'Е. Ю. Горина'],
                  ['Начальник Центра по работе со студентами Высшей школы печати и медиаиндустрии', 'Л. Л. Бутарева']]
        elsif '7' == params[:sign]
          data = [['Директор Высшей школы печати и медиаиндустрии', 'К. В. Антипов']#,
                  #['Начальник студенческого отдела кадров', 'Бутарева Л. Л.']
                  ]
        elsif '5' == params[:sign]
          data = [['Заместитель начальника Центра по работе со студентами ВШПиМ', 'Н. Е. Уткина']#,
                  #['Начальник студенческого отдела кадров', 'Бутарева Л. Л.']
                  ]
        else
          positions = []
          if '3' == params[:sign]
            roles = ['student_hr_boss_zam_doc']
          elsif '4' == params[:sign]
            roles = ['pro-rector-study', 'student_hr_boss_zam_doc']
          elsif '5' == params[:sign]
            roles = ['student_hr_boss_zam_student']
          elsif '6' == params[:sign]
            roles = ['pro-rector-study', 'student_hr_boss_zam_student']
          else
            roles = (params[:sign] == '0' ? ['student_hr_boss'] : ['pro-rector-study', 'student_hr_boss'])
          end
          roles.each do |role|
            positions << Position.from_role(role).first
          end

          data = []
          positions.each do |p|
            title = Unicode::capitalize(p.title)
            if p.role.name != 'student_hr_boss'
              data << [
                title, p.user.short_name]
            else
              data << [
                "#{title} #{p.department.name_rp}", p.user.short_name]
            end
          end
        end

        pdf.move_down 10
        pdf.table data, header: true, width: pdf.bounds.width, cell_style: { padding: [4, 2], border_color: 'ffffff' } do
          column(1).style align: :right
          column(1).width = 200
          row(0).height = 40
        end
      end


    pdf.move_down 10

   pdf.font_size 8 do
      pdf.text "Исполнитель: <u>#{current_user.full_name}</u>", inline_format: true
      pdf.text "Тел.: #{(current_user.is?(:student_hr) || current_user.is?(:student_hr_boss) || current_user.is?(:student_hr_boss_zam_student) || current_user.is?(:student_hr_boss_zam_doc)) ? '+7 (499) 976-37-77' : current_user.phone}"
    end


  end
end
