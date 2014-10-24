pdf.font_size 14 do
  pdf.text 'СПРАВКА', style: :bold, align: :center
  pdf.text 'о результатах единого государственного экзамена', style: :bold, align: :center
end

pdf.move_down 15

pdf.font_size 11 do
  pdf.text entrant.full_name, align: :center
  pdf.text "Паспорт #{entrant.pseries} №#{entrant.pnumber}", align: :center
end

pdf.move_down 10

if check.results.empty?
  pdf.font_size 11 do
    pdf.move_down 10
    pdf.text 'Проверка в АИС «Федеральная база свидетельств о результатах ЕГЭ» (Свидетельство о государственной регистрации базы данных №2010620233), действующей на основании Приказа Минобрнауки России от 15 апреля 2009 года №133 для образовательного учреждения'
    pdf.text 'федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова»', style: :bold
    pdf.text 'не обнаружила действительных свидетельств по результатам сдачи единого государственного экзамена.'
  end
else
  pdf.font_size 11 do
    pdf.text "В соответствии с проверкой действительных результатов сдачи единого государственного экзамена #{entrant.full_name} обнаружил#{'а' if entrant.female?} следующие знания по общеобразовательным предметам:", align: :justify
  end

  pdf.move_down 10

  data = [
    ['Наименование общеобразовательных предметов', 'Баллы', 'Год']
  ]
  check.results.each do |result|
    data << [result.exam_name, result.score, result.year]
  end

  pdf.font_size 11 do
    pdf.table data, header: true
    pdf.move_down 10
    pdf.text 'Справка для личного дела абитуриента сформирована из подсистемы ФИС «Результаты ЕГЭ» для образовательного учреждения:'
    pdf.text 'федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова»', style: :bold
  end
end

pdf.font_size 11 do
  pdf.move_down 30
  pdf.text 'Лицо, сформировавшее справку:'
  pdf.text 'технический секретарь                                                       ___________________ / _____________________ /'
  pdf.font_size 8 do
    pdf.indent 50 do
      pdf.text 'подпись                            расшифровка                     ', align: :right
    end
  end
  pdf.move_down 15
  pdf.text 'Ответственное лицо приемной комиссии:'
  pdf.text 'ответственный секретарь                                                   ___________________ / Е. Л. Хохлогорская /', inline_format: true
  pdf.font_size 8 do
    pdf.indent 50 do
      pdf.text 'подпись                                                                           ', align: :right
    end
  end

  pdf.move_down 30
  pdf.text 'М. П.', align: :center

  pdf.move_down 30
  pdf.text "Дата выдачи: #{l check.date}     Личное дело: #{entrant.packed_application.number}     Регистрационный номер: #{check.id}", align: :center
end