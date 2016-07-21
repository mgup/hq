prawn_document margin: [56.692913386, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  pdf.font_size 11 do
    pdf.text 'АКТ ПЕРЕДАЧИ ДОГОВОРОВ', style: :bold, align: :center
    pdf.move_down 20
    @contracts.group_by(&:competitive_group).each do |group, contracts|
      pdf.text group.name
      pdf.move_down 5
      contracts.each_with_index do |contract, i|
        pdf.indent 25 do
          pdf.text "#{i+1}. #{contract.entrant.full_name} (#{contract.bilateral? ? '2 экземпляра' : '3 экземпляра'})"
        end
        pdf.move_down 3
      end
      pdf.move_down 15
    end

    pdf.text 'Настоящий акт отпечатан в 2-х экземплярах.'
    pdf.move_down 10
    pdf.text "Начальник студенческого отдела кадров #{' '*70} / Л.Л. Бутарева /"

  end

end
