prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Список студентов группы #{@group.name}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: 'Списочный состав учебной группы'

  headData = [['Группа', @group.name ], ['Институт', @group.speciality.faculty.name], ['Форма обучения', study_form_name(@group.form)], [Unicode::capitalize(speciality_type(@group.speciality)), @group.speciality.code + ' ' + @group.speciality.name]]
  pdf.font_size 11 do
      pdf.table headData, header: true, width: pdf.bounds.width,
                cell_style: { padding: 1, border_color: 'ffffff' }
    end

  pdf.move_down 13

  data = [['№', 'ФИО', '', 'Статус', 'Примечание']]
  @group.students.actual.each_with_index do |s, index|
    data << [index + 1, s.person.full_name, s.id, s.status_name, '']
  end

  pdf.font_size 10 do
    pdf.table data, header: true, width: pdf.bounds.width,
        column_widths: [15, 200, 32], cell_style: { padding: 2 } do
      row(0).style align: :center
    end
  end

  pdf.font_size 11 do
    pdf.number_pages "Директор #{@group.speciality.faculty.abbreviation}: __________________ / __________________ /         #{Date.today.strftime('%d.%m.%Y')}", at: [pdf.bounds.left + 150, 12]
  end
end