prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Справка для #{@student.person.full_name(:rp)}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/font', pdf: pdf
  # render 'pdf/header', pdf: pdf, title: ''

  count = params[:count].to_i
  count.times do |i|
    pdf.start_new_page if i > 0
    pdf.image "#{Rails.root}/app/assets/images/logo.jpg", at: [0,785], scale: 0.20

    pdf.indent 120 do
      pdf.font 'PTSerif', size: 10, style: :bold, align: :center do
        pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
        pdf.text 'федеральное государственное бюджетное образовательное', align: :center
        pdf.text 'учреждение высшего профессионального образования', align: :center
        pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ', align: :center
        pdf.text 'ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center
      end

    end

    pdf.line_width = 2
    pdf.stroke do
      pdf.move_down 3
      pdf.horizontal_rule
    end

    pdf.line_width = 0.5
    pdf.stroke do
      pdf.move_down 2
      pdf.horizontal_rule
    end

    pdf.move_down 15
    pdf.font_size 9 do
      pdf.text '127550, Москва, Прянишникова, 2а'
      pdf.text 'Тел.: (499) 976-39-73, факс: (499) 976-06-35'
      pdf.text 'e-mail: info@mgup.ru    www.mgup.ru'
      pdf.text '№____________________________________'
      pdf.text 'На______________от___________________'
    end

    pdf.move_down 23

    pdf.font_size 16 do
      if count > 1
        pdf.text "СПРАВКА № #{@reference.number}/#{i+1} от «<u>#{l @reference.date, format: '%d'}</u>» <u>#{l @reference.date, format: '%B'}</u> #{l @reference.date, format: '%Y'}г.", inline_format: true, align: :center, style: :bold
      else
        pdf.text "СПРАВКА № #{@reference.number} от «<u>#{l @reference.date, format: '%d'}</u>» <u>#{l @reference.date, format: '%B'}</u> #{l @reference.date, format: '%Y'}г.", inline_format: true, align: :center, style: :bold
      end
    end



     birth = params[:addBirthday] ? (@student.person.birthday ? ", <u>#{l(@student.person.birthday, format: '%d %B %Y')}</u>  года рождения," : '') : ''

    institute = @student.group.speciality.faculty.name.split
    institute[0]+='а'

    tax = params[:addTax] ? " #{@student.budget? ? '<u>бюджетной</u>' : '<u>договорной</u>'} основы" : ''
    license = params[:addLicense] ? ', осуществляющем образовательную деятельность на основании <u>Лицензии, серия ААА №001773, выданной Федеральной службой по надзору в сфере образования и науки, регистрационный №1704 от 11 августа 2011 г., и Свидетельства о государственной аккредитации, серия ВВ №001559, выданного Федеральной службой по надзору в сфере образования и науки на срок по 19 марта 2018 г., регистрационный №1542 от 19 марта 2012 г</u>' : ''
    last_year = @student.last_status_order.signing_date.year
    years = @student.is_valid? ? "#{Study::Discipline::CURRENT_STUDY_YEAR}/#{Study::Discipline::CURRENT_STUDY_YEAR+1}" : (@student.last_status_order.signing_date.month > 8 ? "#{last_year}/#{last_year+1}" : "#{last_year-1}/#{last_year}")


    pdf.font_size 12 do
      pdf.move_down 20
      pdf.text "Выдана <b><u>#{@student.person.full_name(:dp)}</u></b>#{birth} о том, что #{@student.sex} действительно #{@student.is_valid? ? 'является' : (@student.person.male? ? 'являлся' : 'являлась')} обучающимся <u>#{@student.group.course}</u> курса#{tax} <u>#{study_form_name(@student.group.form, :rp)}</u> формы обучения в #{years} учебном году по #{@student.group.speciality.name_tvor} <u>#{@student.group.speciality.code}</u> — «<u>#{@student.group.speciality.name}»</u> в ФГБОУ ВПО «Московский государственный университет печати имени Ивана Федорова»#{license}.", inline_format: true, align: :justify
      pdf.move_down 25

     if params[:orders]
        Office::Order.find(params[:orders]).each_with_index do |order, index|
           pdf.text "#{index+1}. Приказ № #{order.number} «#{order.name if order.template}» от #{order.signing_date.strftime('%d.%m.%Y') if order.signing_date}"
        end
     pdf.move_down 25
     end

    if params[:addPeriod]
      pdf.text "Нормативный срок обучения по #{@student.group.speciality.name_tvor} на #{study_form_name(@student.group.form, :pp)} форме обучения: <u>#{@student.group.study_length.round} #{@student.group.study_length > 4 ? 'лет' : 'года'}</u>", inline_format: true
      pdf.text "Срок обучения: <u>с #{params[:dateIn]} по #{params[:dateOut]}</u>", inline_format: true
    end

      pdf.move_down 25
      pdf.text 'Выдана для предоставления'
      pdf.move_down 5
      pdf.text params[:place], align: :center
      pdf.move_up 13
      pdf.text '_'*100

      pdf.move_down 25
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

      pdf.move_down 25
      data = []
      positions.each do |p|
      title = Unicode::capitalize(p.title)
        if p.role.name == 'pro-rector-study'
          data << [
              title, p.user.short_name]
        else
          data << [
            "#{title} #{p.department.name_rp}", p.user.short_name]
        end
      end

      pdf.table data, header: true, width: pdf.bounds.width, cell_style: { padding: 7, border_color: 'ffffff' } do
        column(1).style align: :right
        column(1).width = 200
      end
    end

    pdf.move_down 50


    # pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 50], width: pdf.bounds.width do
    #     pdf.font_size 10 do
    #           pdf.text 'Исполнитель:'
    #           pdf.text "#{current_user.full_name}"
    #           pdf.text "Тел.: #{(current_user.is?(:student_hr) || current_user.is?(:student_hr_boss)) ? '+7 (499) 976-37-77' : current_user.phone}"
    #     end
    #end
  end
 end
