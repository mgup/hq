prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Справка для #{@student.person.full_name(:rp)}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: ''

  pdf.move_down 15
  pdf.font_size 10 do
    pdf.text '127550, Москва, Прянишникова, 2а'
    pdf.text 'Тел.: (499) 976-39-73, факс: (499) 976-06-35'
    pdf.text 'e-mail: info@mgup.ru    www.mgup.ru'
    pdf.text '№____________________________________'
    pdf.text 'На______________от___________________'
  end

  pdf.move_down 30

  pdf.font_size 16 do
    pdf.text "СПРАВКА № #{@reference.number} от «__» __________ 20____г.", align: :center, style: :bold
  end


   birth = params[:addBirthday] ? (@student.person.birthday ? ", <u>#{l(@student.person.birthday, format: '%d %B %Y')}</u>  года рождения," : '') : ''

  institute = @student.group.speciality.faculty.name.split
  institute[0]+='а'

  tax = params[:addTax] ? ", на #{@student.budget? ? 'бюджетной' : 'договорной'} основе обучения" : ''

  pdf.font_size 12 do
    pdf.move_down 40
    pdf.text "Выдана <u>#{@student.person.full_name(:dp)}</u>#{birth} о том, что #{@student.sex} действительно является студентом <u>#{@student.group.course}</u> курса <u>#{study_form_name(@student.group.form, :rp)}</u> формы обучения <u>#{institute.join(' ')}</u> по #{@student.group.speciality.specialist? ? 'специальности' : 'направлению'} <u>#{@student.group.speciality.code}</u> - «<u>#{@student.group.speciality.name}»</u> ФГБОУ ВПО «Московский государственный университет печати имени Ивана Федорова»#{tax}.", inline_format: true
    pdf.move_down 25

   if params[:orders]
      Office::Order.find(params[:orders]).each_with_index do |order, index|
         pdf.text "#{index+1}. Приказ № #{order.number} «#{order.name if order.template}» от #{order.signing_date.strftime('%d.%m.%Y') if order.signing_date}"
      end
   end
   pdf.move_down 25

  if params[:addPeriod]
    yearIn = params[:dateIn].split('.').last.to_i
    yearOut = params[:dateOut].split('.').last.to_i
    pdf.text "Нормативный срок обучения: #{yearOut - yearIn} #{(yearOut - yearIn) > 4 ? 'лет' : 'года'}"
    pdf.text "Срок обучения студента: с #{params[:dateIn]} по #{params[:dateOut]}"
  end

    pdf.move_down 25
    pdf.text 'Выдана для предоставления'
    pdf.move_down 5
    pdf.text params[:place], align: :center
    pdf.move_up 13
    pdf.text '_'*100

    pdf.move_down 25
    positions = []
    roles = (params[:sign] == '0' ? ['student_hr_boss'] : ['pro-rector-study', 'student_hr_boss'])
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
          "#{title} #{p.department.abbreviation}", p.user.short_name]
      end
    end

    pdf.table data, header: true, width: pdf.bounds.width, cell_style: { padding: 7, border_color: 'ffffff' } do
      column(1).style align: :right
    end
  end

  pdf.move_down 50


  pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 50], width: pdf.bounds.width do
      pdf.font_size 10 do
            pdf.text 'Исполнитель:'
            pdf.text "#{current_user.full_name}"
            pdf.text "Тел.: #{(current_user.is?(:student_hr) || current_user.is?(:student_hr_boss)) ? '+7 (499) 976-37-77' : current_user.phone}"
      end
    end

 end
