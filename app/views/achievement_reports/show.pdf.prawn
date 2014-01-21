prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               #filename: "Отчёт за #{@period.description}.pdf",
               page_size: 'A4', page_layout: :portrait, inline: true do |pdf|
  render 'pdf/header', pdf: pdf, title: "Отчёт по показателям эффективности\n за #{@period.description}"

    data = []
    activities = []
    index = 0
    @achievements.group_by { |a| a.activity }.each do |activity, achievements|
      activities << index
      data << [activity.name]
      index+=1
      achievements.each do |a|
        data << ['• ' + a.description]
        index+=1
      end
    end

    pdf.font_size 10 do
      pdf.font_size 11 do
        pdf.text "НПР: #{current_user.full_name}", inline_format: true
        pdf.text "Версия отчёта: ##{@report.id} от #{l @report.updated_at, format: '%d %B %Y'}", inline_format: true
      end

      pdf.move_down 10
      pdf.table data, width: pdf.bounds.width, cell_style: { padding: 2,  border_width: [0,0] } do
        activities.each do |i|
         row(i).style(font_style: :bold, border_width: 0, padding: 4).size = 11
        end
        row(index-1).style border_width: [0,0,0,0]
      end

      pdf.move_down 30
      pdf.text 'НПР:'
      pdf.move_down 5
      pdf.text '«____» _______________ 20____ г.                                                                                       ___________________ / ___________________'
      pdf.font_size 8 do
       pdf.indent 370 do
          pdf.text 'подпись                     расшифровка'
       end
      end
      pdf.move_down 10
      pdf.text 'Заведующий кафедрой:'
      pdf.move_down 5
      pdf.text '«____» _______________ 20____ г.                                                                                       ___________________ / ___________________'
      pdf.font_size 8 do
       pdf.indent 370 do
         pdf.text 'подпись                     расшифровка'
       end
      end
    end
end