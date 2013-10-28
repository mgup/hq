prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: ''

   title =  [['Список студентов',  Date.today.strftime("%d.%m.%Y") ]]
   pdf.font_size 12 do
      pdf.table title, header: true, width: 510.24062992108657,
                    cell_style: { padding: 2, border_color: "ffffff" } do
         column(1).style align: :right
      end
   end

  pdf.move_down 20

  headData = [['Группа', @group.name ], ['Институт', @group.speciality.faculty.name], ['Форма', @group.this_form], ['Направление', @group.speciality.code + ' ' + @group.speciality.name]]
  pdf.font_size 12 do
      pdf.table headData, header: true, width: 510.24062992108657,
                cell_style: { padding: 2, border_color: "ffffff" }
    end

  pdf.move_down 13

 off_budget = []
  data = [['№', '#', 'ФИО', 'Примечание']]
  @group.students.each_with_index do |s, index|
    data << [index + 1, s.id, s.person.full_name, '']
    off_budget << (index + 1) if s.off_budget?
  end

  pdf.font_size 10 do
    pdf.table data, header: true, width: 510.24062992108657,
        column_widths: [15, 32, 200], cell_style: { padding: 2 } do
      row(0).style align: :center
      off_budget.each do |i|
       row(i).background_color = "d3d3d3"
      end
    end
  end

end