prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Список студентов группы #{@discipline.group.name}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: "СОСТАВ УЧЕБНОЙ ГРУППЫ #{@discipline.group.name}"

  pdf.text @discipline.name
  pdf.text "#{@discipline.semester}-й семестр #{study_year(@discipline.year)} учебного года"
  pdf.text @discipline.lead_teacher.full_name

  pdf.move_down 13

  data = [['№', 'Студент', '#', '', '', '', '']]
  @students.each_with_index do |s, index|
    data << [index + 1, s.person.full_name, s.id, '', '', '', '']
  end

  pdf.font_size 10 do
    pdf.table data, header: true, width: pdf.bounds.width,
              column_widths: [15, 200, 32], cell_style: { padding: 2 }
  end
end