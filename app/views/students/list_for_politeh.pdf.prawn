prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Приложение.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/font', pdf: pdf

  pdf.font_size 11 do
    pdf.bounding_box([270,  pdf.bounds.top], width: 250) do
      pdf.text 'Приложение 1.1'
      pdf.text 'к приказу от «___»______________2016 года № _____'
    end
  end
  pdf.move_down 10
  pdf.font 'PTSerif', size: 14 do
    pdf.text 'СТУДЕНТЫ', align: :center
    pdf.text 'МОСКОВСКОГО ГОСУДАРСТВЕННОГО УНИВЕРСИТЕТА ПЕЧАТИ', align: :center
    pdf.text 'ИМЕНИ ИВАНА ФЕДОРОВА, ПЕРЕВЕДЕННЫЕ', align: :center
    pdf.text 'С 01 СЕНТЯБРЯ 2016 ГОДА', align: :center
    pdf.text 'В МОСКОВСКИЙ ПОЛИТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ', align: :center
  end

  pdf.move_down 15
  list = false
   @students.group_by(&:faculty).each do |faculty, fstudents|
     next unless faculty
     pdf.start_new_page if list
     list = true
     pdf.move_down 15
     pdf.font 'PTSerif', size: 14 do
       pdf.text faculty.name.mb_chars.upcase, align: :center
     end

     fstudents.group_by(&:speciality).each do |speciality, sstudents|
       next if speciality.aspirant?
       pdf.move_down 10
       pdf.font 'PTSerif', size: 12, style: :bold do
         pdf.text "#{speciality.specialist? ? 'Специальность' : 'Направление подготовки'} #{speciality.full_name} ", align: :center
       end

       sstudents.group_by{|s| s.group.form }.each do |form, formstudents|
         next if (['oz_distance', 'distance'].include? form)
         pdf.font 'PTSerif', size: 12 do
           pdf.move_down 15
           pdf.text "Форма обучения: #{study_form_name(form, :ip)}", align: :center

           formstudents.group_by{|s| s.group.course }.sort_by{|c, _| c}.each do |course, cstudents|
             pdf.font 'PTSerif', size: 12 do
               pdf.move_down 10
               pdf.text "На #{course} курс:"
               pdf.move_down 5

               cstudents.group_by{|s| s.group }.sort_by{|g, _| g.number}.each do |group, groupstudents|
                 pdf.font 'PTSerif', size: 11 do
                   pdf.move_down 5
                   pdf.text "Группа #{group.name}"

                   data = [['№', 'Фамилия Имя Отчество', 'Основа обучения: платная договорная /бюджетная /обучение по целевому договору']]
                   groupstudents.each_with_index do |s, index|
                     data << ["#{index + 1}.", s.person.full_name, (s.target? ? 'обучение по целевому договору' : (s.budget? ? 'бюджетная' : 'платная договорная')) ]
                   end

                   pdf.font_size 11 do
                     pdf.move_down 5
                     pdf.table data, header: true, width: pdf.bounds.width,
                               column_widths: [20, 320, 170.24062992108657], cell_style: { padding: 2 } do
                       row(0).style align: :center
                       column(0).style align: :center
                       column(2).style align: :center
                     end
                   end
                   pdf.move_down 5
                 end
               end
               pdf.move_down 5
               pdf.font_size 12 do
                 pdf.text "Всего на #{course} курс по #{study_form_name(form, :pp)} форме обучения: #{cstudents.length} #{Russian::pluralize(cstudents.length, 'человек', 'человека', 'человек')}"
               end
             end
           end
         end
       end
     end
   end

end
