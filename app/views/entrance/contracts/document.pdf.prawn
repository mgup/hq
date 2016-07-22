prawn_document margin: [56.692913386, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  index = 0
  @contracts.group_by{ |c| c.competitive_group.faculty }.each do |_, contracts|
    pdf.start_new_page unless index == 0
    index += 1
    pdf.font_size 11 do
    pdf.text 'АКТ ПЕРЕДАЧИ ДОГОВОРОВ', style: :bold, align: :center
    pdf.move_down 20

    contracts.group_by(&:competitive_group).each do |group, cs|
      pdf.text group.name
      pdf.move_down 5
      cs.each_with_index do |contract, i|
        pdf.indent 25 do
          pdf.text "#{i+1}. #{contract.entrant.full_name} (#{(contract.count? ? contract.count : (contract.bilateral? ? 2 : 3))} #{
                   Russian::p((contract.count? ? contract.count : (contract.bilateral? ? 2 : 3)),
                              'экземпляр',
                              'экземпляра',
                              'экземпляров')
                     })"
        end
        pdf.move_down 3
      end
      pdf.move_down 15
    end

    pdf.move_down 25
    pdf.text 'Настоящий акт отпечатан в 2-х экземплярах.'
    pdf.move_down 15
    pdf.text "Начальник студенческого отдела кадров #{' '*70} /  Л. Л. Бутарева  /"
    pdf.move_down 10
    pdf.text "______________________________________________ #{' '*69} / __________________ /"

    end
  end
end
