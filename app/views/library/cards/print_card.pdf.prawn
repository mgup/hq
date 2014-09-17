prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Читательский билет № #{@rdr_id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
 render 'pdf/font', pdf: pdf
 pdf.font_size = 8
 pdf.image "#{Rails.root}/app/assets/images/library/reader1.png", at: [50,700], scale: 0.75
 pdf.image "#{Rails.root}/app/assets/images/library/reader2.png", at: [50,450], scale: 0.75
 pdf.image "#{Rails.root}/app/assets/images/library/barcode.png", at: [185,588], width: 125, height: 30
 pdf.text_box "#{@rdr_id}", at: [173, 533], character_spacing: 10, style: :bold
 pdf.font_size = 10
 pdf.text_box "#{@reader_last_name}", at: [217, 635]
 pdf.text_box "#{@reader_first_name}", at: [217, 622]
 pdf.text_box "#{@reader_patronym}", at: [217, 609]
end