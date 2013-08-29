pdf.font_families.update(
    'PT'=> {
        normal: Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf').to_s,
        italic: Rails.root.join('app', 'assets', 'fonts', 'PTF56F.ttf').to_s,
        bold:   Rails.root.join('app', 'assets', 'fonts', 'PTF75F.ttf').to_s})
pdf.font 'PT', size: 12

pdf.font 'PT', size: 11, style: :bold, align: :center do
  pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ', align: :center
  pdf.text 'федеральное государственное бюджетное образовательное', align: :center
  pdf.text 'учреждение высшего профессионального образования', align: :center
  pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ ИМЕНИ ИВАНА ФЕДОРОВА»', align: :center
end

pdf.line_width = 3
pdf.stroke do
  pdf.move_down 3
  pdf.horizontal_rule
end

pdf.line_width = 0.5
pdf.stroke do
  pdf.move_down 3
  pdf.horizontal_rule
end
pdf.move_down 13

pdf.text title, size: 14, style: :bold, align: :center
pdf.move_down 13
