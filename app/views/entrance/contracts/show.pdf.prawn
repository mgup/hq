prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  render 'contract', pdf: pdf

  pdf.start_new_page

  render 'contract', pdf: pdf

  if @contract.trilateral?
    pdf.start_new_page

    render 'contract', pdf: pdf
  end

  pdf.start_new_page
end
