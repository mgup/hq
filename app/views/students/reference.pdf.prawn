prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: ''
  reference = 1
  pdf.move_down 15
  pdf.font 'PT', size: 10 do
    pdf.text '127550, Москва, Прянишникова, 2а'
    pdf.text 'Тел.: (499) 976-39-73, факс: (499) 976-06-35'
    pdf.text 'e-mail: info@mgup.ru    www.mgup.ru'
    pdf.text '№____________________________________'
    pdf.text 'На______________от___________________'
  end

  pdf.move_down 30

  pdf.font 'PT', size: 16, style: :bold do
    pdf.text "СПРАВКА № #{reference} от «__» __________ 20____г.", align: :center
  end

  birthday = @student.person.birthday
  if birthday
    month = case birthday.strftime("%m")
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
    birth = ", <u>#{birthday.strftime("%d")} #{month} #{birthday.strftime("%Y")}</u>  года рождения,"
  end
  institute = @student.group.speciality.faculty.name.split
  institute[0]+='а'

  pdf.font 'PT', size: 12 do
    pdf.move_down 40
    pdf.text "Выдана <u>#{@student.person.full_name(:dp)}</u>#{birth} о том, что #{@student.sex} действительно является студентом <u>#{@student.group.course}</u> курса <u>#{@student.group.support}</u> формы обучения <u>#{institute.join(' ')}</u> по #{@student.group.speciality.specialist? ? 'специальности' : 'направлению'} <u>#{@student.group.speciality.code}</u> - «<u>#{@student.group.speciality.name}»</u> ФГБОУ ВПО «Московский государственный университет печати имени Ивана Фёдорова», на #{@student.budget? ? 'бюджетной' : 'договорной'} основе обучения.", inline_format: true
    pdf.move_down 25

    @student.orders.each_with_index do |order, index|
       pdf.text "#{index+1}. Приказ № #{order.number} «#{order.name if order.template}» от #{order.signing_date.strftime("%d.%m.%Y")}"
    end
    pdf.move_down 25
    pdf.text "Нормативный срок обучения: #{@student.study_time.round} #{@student.study_time.to_i > 4 ? 'лет' : 'года'}"
    pdf.text "Срок обучения студента: с 01.09.#{@student.admission_year} по 30.06.#{@student.study_time.to_i + @student.admission_year.to_i}"

    pdf.move_down 25
    pdf.text 'Выдана для предоставления'
    pdf.text '_'*100

    pdf.move_down 25
    prorector = User.from_position('первый проректор по учебной работе').first.short_name_official
    student_hr = User.from_position('начальник студенческого отдела кадров').first.short_name_official
    pdf.move_down 25
    data = [['Первый проректор по учебной работе', "#{prorector}"], ['Начальник студенческого отдела кадров', "#{student_hr}"]]
    pdf.table data, header: true,  width: 510.24062992108657, cell_style: { padding: 7, border_color: "ffffff" } do
      column(1).style align: :right
    end
  end

  pdf.move_down 50
  pdf.font 'PT', size: 10 do
      pdf.text 'Исполнитель:'
      pdf.text "#{current_user.full_name}"
      pdf.text "Тел.: #{current_user.phone}"
  end

 end
