prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Экзаменационная ведомость № #{@exam.id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/header', pdf: pdf, title: "ЭКЗАМЕНАЦИОННАЯ (ЗАЧЁТНАЯ) ВЕДОМОСТЬ № #{@exam.id}"

headData = [['Семестр', Study::Discipline::CURRENT_STUDY_TERM ], ['Институт', @group.speciality.faculty.name], ['Форма', @group.this_form], ['Направление', @group.speciality.code + ' ' + @group.speciality.name]]
  pdf.font_size 12 do
      pdf.table headData, header: true, width: pdf.bounds.width,
                cell_style: { padding: 2, border_color: "ffffff" }
    end
 end