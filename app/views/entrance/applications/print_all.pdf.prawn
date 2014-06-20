prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               # filename: "Заявление № #{@entrant.id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

    @entrant.applications.each do |ap|
        render 'application', pdf: pdf, application: ap, entrant: @entrant
        pdf.start_new_page
    end

 end