prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Приложение к приказу.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
 render 'pdf/font', pdf: pdf
 data = []
 if params[:dates]
  dates = @event.dates.find(params[:dates].split(','))
 else
  dates = @event.dates
 end
 dates.each do |date|
  date.visitors.each do |visitor|
    data << {name: visitor.full_name, date: (l date.date), department: (visitor.departments.empty? ? (visitor.user_department? ? Department.find(visitor.user_department).name : '') : visitor.departments.first.name) }
  end
 end
 table_data = [['№ п/п', 'ФИО', 'Дата профосмотра', 'Структурное подразделение']]
 data.sort_by { |d| d[:name] }.each_with_index do |visitor, index|
   table_data << ["#{index+1}", visitor[:name], visitor[:date], visitor[:department]]
 end

 pdf.font_size 10 do
  pdf.indent 320 do
      pdf.text 'Приложение №1 к приказу'
      pdf.text 'ректора МГУП имени Ивана Федорова'
      pdf.text 'от «___» ____________ 20____ г. № ____________'
    end
   pdf.font_size 11 do
     pdf.move_down 15
     if params[:dates]
       pdf.text "Список работников, направляемых на ежегодный\n периодический профосмотр #{dates.collect{|d| (l d.date, format: '%d %B')}.join(', ')} 2014 г.", style: :bold, align: :center
      else
       pdf.text "Список работников, направляемых на ежегодный\n периодический профосмотр.", style: :bold, align: :center
      end
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