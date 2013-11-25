prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Успеваемость #{@group.name} на #{l Date.today}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/header', pdf: pdf, title: "Успеваемость #{@group.name}"
  discipline = Study::Discipline.find(params[:discipline]) if params[:discipline]
  pdf.text  (params[:discipline] ? discipline.name : 'По всем предметам')
  pdf.text "#{Study::Discipline::CURRENT_STUDY_TERM}-й семестер #{Study::Discipline::CURRENT_STUDY_YEAR} учебного года"
  pdf.text discipline.lead_teacher.full_name if params[:discipline]

  pdf.move_down 13

  data = [['№', 'Студент', '#', "Набранный балл на #{l Date.today}", "Средняя оценка на #{l Date.today}"]]
  @group.students.each_with_index do |s, index|
    data << [index + 1, s.person.full_name, s.id, s.ball(discipline), s.result(discipline)[:mark]]
  end

  pdf.font_size 10 do
    pdf.table data, header: true, width: pdf.bounds.width,
              column_widths: [15, 200, 32], cell_style: { padding: 2 }
  end
end