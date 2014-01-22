prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Приложение к приказу на #{l @date.date}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
 render 'pdf/font', pdf: pdf
 data = []
 @date.visitors.each do |visitor|
   data << {name: visitor.full_name, date: (l @date.date), department: (visitor.departments.empty? ? (visitor.user_department? ? Department.find(visitor.user_department).name : '') : visitor.departments.first.name) }
 end

 table_data = [['№ п/п', 'ФИО', 'Дата профосмотра', 'Структурное подразделение']]
 data.sort_by { |d| d[:name] }.each_with_index do |visitor, index|
   table_data << ["#{index+1}.", visitor[:name], visitor[:date], visitor[:department]]
 end

 pdf.font_size 10 do
  pdf.indent 320 do
      pdf.text 'Приложение №1 к приказу'
      pdf.text 'ректора МГУП имени Ивана Федорова'
      pdf.text 'от «___» ____________ 20____ г. № ____________'
    end
   pdf.font_size 11 do
     pdf.move_down 15
     pdf.text "Список работников, направляемых на ежегодный периодический\n профосмотр #{l @date.date, format: :long} г.", style: :bold, align: :center
   end
   pdf.move_down 10
   pdf.table table_data, width: pdf.bounds.width, cell_style: { padding: [2, 4] } do
    row(0).style align: :center
    column(0).style align: :center
    column(2).style align: :center
    column(0).width = 25
   end
 end
end