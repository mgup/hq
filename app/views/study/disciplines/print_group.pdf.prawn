prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: "СОСТАВ УЧЕБНОЙ ГРУППЫ #{@discipline.group.name}"

  pdf.text @discipline.name
  pdf.text "#{@discipline.semester}-й семестер #{study_year(@discipline.year)} учебного года"
  pdf.text @discipline.lead_teacher.full_name

  pdf.move_down 13

  data = [['№', 'Студент', '#', '', '', '', '']]
  @discipline.group.students.each_with_index do |s, index|
    data << [index + 1, s.person.full_name, s.id, '', '', '', '']
  end

  pdf.font_size 10 do
    pdf.table data, header: true, width: 510.24062992108657,
              column_widths: [23, 220, 41], cell_style: { padding: 2 }
  end
end