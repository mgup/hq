require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

prawn_document margin: [50, 20, 20, 20],
               filename: "Читательские билеты группа #{@group.name}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
  render 'pdf/font', pdf: pdf
  @group.students.valid_for_today.select{ |s| s.rdr_id != false }.each_with_index do |student, i|
    pdf.start_new_page if (i%4 == 0 && i != 0)
    rdr_id = student.rdr_id
    pdf.font_size = 8
    pdf.image "#{Rails.root}/app/assets/images/library/reader1.png", at: [-3,800 - (i%4)*200], scale: 0.75
    pdf.image "#{Rails.root}/app/assets/images/library/reader2.png", at: [292,800 - (i%4)*200], scale: 0.75
    barcode = Barby::Code128B.new(rdr_id)
    blob = Barby::PngOutputter.new(barcode).to_png(height: 65, margin: 0)
    File.open('app/assets/images/library/barcode.png', 'w'){|f| f.write blob }
    pdf.image "#{Rails.root}/app/assets/images/library/barcode.png", at: [117,688 - (i%4)*200], width: 125, height: 30
    pdf.text_box "#{rdr_id}", at: [120, 653 - (i%4)*200], character_spacing: 7, style: :bold
    pdf.font_size = 10
    pdf.text_box "#{student.person.last_name}", at: [164, 743 - (i%4)*200]
    pdf.text_box "#{student.person.first_name}", at: [164, 730 - (i%4)*200]
    pdf.text_box "#{student.person.patronym}", at: [164, 719 - (i%4)*200]
  end
end