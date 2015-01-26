previous_size = pdf.font_size

pdf.font_size(12) do
  pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ',
           align: :center, style: :bold
end

pdf.font_size(14) do
  pdf.text 'федеральное государственное бюджетное образовательное учреждение высшего профессионального образования',
           align: :center, style: :bold
  pdf.text '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ',
           align: :center, style: :bold
  pdf.text 'ИМЕНИ ИВАНА ФЕДОРОВА»',
           align: :center, style: :bold
end

pdf.line_width = 2
pdf.stroke do
  pdf.move_down 3
  pdf.horizontal_rule
end

pdf.line_width = 0.5
pdf.stroke do
  pdf.move_down 2
  pdf.horizontal_rule
end
pdf.move_down 13

pdf.font_size 12

page_width = pdf.bounds.width
time_width = pdf.width_of(l(Time.now), size: 8)
gap = page_width - time_width
pdf.bounding_box([0, pdf.cursor], width: page_width) do
  pdf.bounding_box([0, 0], width: gap) do
    pdf.text title, style: :bold if defined?(title)
  end
  pdf.bounding_box([gap,  pdf.bounds.top], width: time_width) do
    pdf.move_down 2.45
    pdf.text l(generated_at), align: :right, size: 8 if defined?(generated_at)
  end

  pdf.move_cursor_to pdf.bounds.bottom
end

pdf.move_down 15

pdf.font_size previous_size