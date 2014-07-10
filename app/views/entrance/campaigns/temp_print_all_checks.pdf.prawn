prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  pdf.font_size 30
  pdf.text @faculty.name
  pdf.font_size 12

  @checks.each do |check|
    pdf.start_new_page
    render partial: 'entrance/checks/check',
           locals: { pdf: pdf, check: check, entrant: check.entrant }
  end
end