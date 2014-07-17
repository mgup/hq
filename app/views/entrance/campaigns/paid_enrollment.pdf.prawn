prawn_document do |pdf|
  render 'reports/header',
         pdf: pdf,
         title: "#{@campaign.name}: статистика платного приёма",
         generated_at: @report.generated_at

  txt = ["Всего заключено #{@report.contracts_count}"]
  txt << Russian::p(@report.contracts_count, 'договор', 'договора', 'договоров')
  txt << 'об образовании на общую сумму'
  txt << number_to_currency(@report.total_sum).gsub(' ', ' ')

  if @report.payed_contracts_count > 0
    txt << "Из них по #{@report.payed_contracts_count}"
    txt << Russian::p(@report.payed_contracts_count,
                      'договору', 'договорам', 'договорам')
    txt << 'уже полностью поступил первый обязательный платёж.'
  else
    txt << 'Ни по одному договору ещё полностью не поступил'
    txt << 'первый обязательный платёж.'
  end

  pdf.text txt.join(' '), indent_paragraphs: 20

  g = Gruff::SideBar.new("#{4 * pdf.bounds.width}x400")
  g.font = ::Rails.root.join('app', 'assets', 'fonts', 'PTF55F.ttf').to_s
  g.theme_greyscale
  # g.title = 'Поступившие платежи'
  g.right_margin = 120
  g.legend_font_size = 15
  g.marker_font_size = 15
  g.data('Поступившие платежи, руб.',
         [@report.received_for_first_term_sum])
  g.data('Суммарный первый обязательный платёж, руб.',
         [@report.expected_for_first_term_sum])
  g.labels = { 0 => '2003', 2 => '2004', 4 => '2005' }
  g.show_labels_for_bar_values = true

  pdf.image StringIO.new(g.to_blob('JPG')), width: pdf.bounds.width
end