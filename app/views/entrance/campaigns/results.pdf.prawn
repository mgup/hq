prawn_document margin: [40.34645669291339, 35.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  key = true
  @exam.test_items.collect {|x| x.competitive_group.items.first.direction}.each do |direction|
   entrants = @entrants.from_direction(direction.id)
      next if entrants.empty? || entrants.collect{|entrant| entrant.exam_results.internal.by_exam(@exam.id).last.score}.compact.empty?
      pdf.start_new_page unless key
      key = false
      pdf.text 'Результаты вступительного испытания', size: 14, align: :center
      pdf.move_down 15
      pdf.text "Направление подготовки: <strong>#{direction.description}</strong>", inline_format: true
      pdf.move_down 6
      pdf.text "Вступительное испытание: <strong>#{@exam.name}</strong>", inline_format: true
      #pdf.text '06 июля 2014 года'

      data = [
          ['№ п/п', 'ФИО поступающего', 'Баллы']
      ]
      i = 0
      entrants.each do |entrant|
        result = entrant.exam_results.internal.by_exam(@exam.id).last.score
            if result
                i+=1
                data << [i, entrant.full_name, result]
            else
                next
            end
      end

      pdf.font_size 11 do
        pdf.move_down 15
        pdf.table data, header: true do
          column(0).width = 40
          column(2).width = 100
        end
        pdf.move_down 15
        pdf.text "К дальнейшим вступительным испытаниям допускаются поступающие, набравшие не менее #{@exam.test_items.from_direction(direction.id).first.min_score} баллов."
      end
  end
end