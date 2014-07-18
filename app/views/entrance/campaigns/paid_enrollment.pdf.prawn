prawn_document do |pdf|
  render 'reports/header',
         pdf: pdf, title: @report.title, generated_at: @report.generated_at

  # pdf.text txt.join(' '), indent_paragraphs: 20

  pdf.image StringIO.new(
              @report.graph_received_expected_sums(
                "#{4 * pdf.bounds.width}x400")),
            width: pdf.bounds.width
end