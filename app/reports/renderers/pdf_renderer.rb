module Renderers
  # Класс для генерации элементов отчётов в формате PDF.
  class PdfRenderer < Renderer
    include Prawn::Rails::PrawnHelper

    attr_accessor :pdf

    def render(&block)
      prawn_document do |pdf|
        @pdf = pdf

        block.call(self)
      end
    end

    def title(report)
      render_report_header
      render_report_title(report)

      pdf.move_down 15
    end

    def text(txt)
      pdf.text txt, align: :justify, indent_paragraphs: 20
    end

    def image(img)
      pdf.image StringIO.new(img), width: pdf.bounds.width
    end

    def table(data, options = {})
      options[:header] ||= true

      pdf.table data, options
    end

    private

    def render_report_header
      pdf.text 'МИНИСТЕРСТВО ОБРАЗОВАНИЯ И НАУКИ РОССИЙСКОЙ ФЕДЕРАЦИИ',
               align: :center, style: :bold, size: 12

      [['федеральное государственное бюджетное образовательное',
        'учреждение высшего профессионального образования'].join(' '),
       '«МОСКОВСКИЙ ГОСУДАРСТВЕННЫЙ УНИВЕРСИТЕТ ПЕЧАТИ',
       'ИМЕНИ ИВАНА ФЕДОРОВА»'].each do |text|
        pdf.text text, align: :center, style: :bold, size: 14
      end

      render_double_line
    end

    def render_report_title(report)
      page_width = pdf.bounds.width
      time_width = pdf.width_of(I18n.l(report.generated_at), size: 8)
      gap = page_width - time_width
      pdf.bounding_box([0, pdf.cursor], width: page_width) do
        pdf.bounding_box([0, 0], width: gap) do
          pdf.text report.title, style: :bold, size: 12
        end
        render_title_generated_at(gap, time_width, report.generated_at)

        pdf.move_cursor_to pdf.bounds.bottom
      end
    end

    def render_title_generated_at(x, width, time)
      pdf.bounding_box([x,  pdf.bounds.top], width: width) do
        pdf.move_down 2.45
        pdf.text I18n.l(time), align: :right, size: 8
      end
    end

    def render_double_line
      [[2, 3], [0.5, 2]].each do |width, down|
        pdf.line_width = width
        pdf.stroke do
          pdf.move_down down
          pdf.horizontal_rule
        end
      end
      pdf.move_down 13
    end
  end
end
