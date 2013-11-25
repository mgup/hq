names = []
@data.each_with_index do |d, i|
  if 0 == i
    d[0][0] = ''
  end

  names << [d[0], d[1]] unless d[0].blank? || d[1].blank?
end

prawn_document size: :A4, page_layout: :portrait do |pdf|
  names.each do |name|
    n = name[0].squish
    d = Unicode::downcase(name[1].squish)

    render 'pdf/header', pdf: pdf, title: 'ЗАПРОС'
    pdf.font_size 11
    pdf.text 'В наркологический диспансер по месту жительства или прописки № __________ .'

    txt = "Просим вас провести освидетельствование сотрудника #{n}, #{d} "
    txt += "для допуска к#{Prawn::Text::NBSP}работе (приказ Минздравсоцразвития РФ №302н от 12.04.2011 г.)."
    pdf.text txt, align: :justify
    pdf.move_down 10

    pdf.text '«____» _________________ 2013 г.                                                                                                  Начальник отдела кадров'
    pdf.text 'Гончарова Н. С.', align: :right
    pdf.move_down 25

    pdf.stroke_horizontal_rule
    pdf.move_down 25

    render 'pdf/header', pdf: pdf, title: 'ЗАПРОС'
    pdf.font_size 11
    pdf.text 'В психоневрологический диспансер по месту жительства или прописки № __________ .'

    txt = "Просим вас провести освидетельствование сотрудника #{n}, #{d} "
    txt += "для допуска к#{Prawn::Text::NBSP}работе (приказ Минздравсоцразвития РФ №302н от 12.04.2011 г.)."
    pdf.text txt, align: :justify
    pdf.move_down 10

    pdf.text '«____» _________________ 2013 г.                                                                                  Начальник отдела кадров'
    pdf.text 'Гончарова Н. С.', align: :right
    pdf.move_down 25

    pdf.stroke_horizontal_rule
    pdf.move_down 25

    render 'pdf/header', pdf: pdf, title: 'ЗАПРОС'
    pdf.font_size 11
    pdf.text 'В кожно-венерологический диспансер по месту жительства или прописки № __________ .'

    txt = "Просим вас провести освидетельствование сотрудника #{n}, #{d} "
    txt += "для допуска к#{Prawn::Text::NBSP}работе (приказ Минздравсоцразвития РФ №302н от 12.04.2011 г.)."
    pdf.text txt, align: :justify
    pdf.move_down 10

    pdf.text '«____» _________________ 2013 г.                                                                                  Начальник отдела кадров'
    pdf.text 'Гончарова Н. С.', align: :right

    pdf.start_new_page
  end
end