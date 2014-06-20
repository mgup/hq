prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               # filename: "Заявление № #{@application.number}.pdf",
               # force_download: false,
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  render 'application', pdf: pdf, application: @application, entrant: @entrant
 end
