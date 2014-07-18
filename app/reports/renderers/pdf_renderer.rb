class Renderers::PdfRenderer < Renderer
  include Prawn::Rails::PrawnHelper

  attr_accessor :pdf

  def render(&block)
    prawn_document do |pdf|
      @pdf = pdf

      block.call(self)
    end
  end

  def title(report)
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
    time_width = pdf.width_of(I18n.l(report.generated_at), size: 8)
    gap = page_width - time_width
    pdf.bounding_box([0, pdf.cursor], width: page_width) do
      pdf.bounding_box([0, 0], width: gap) do
        pdf.text report.title, style: :bold
      end
      pdf.bounding_box([gap,  pdf.bounds.top], width: time_width) do
        pdf.move_down 2.45
        pdf.text I18n.l(report.generated_at), align: :right, size: 8
      end

      pdf.move_cursor_to pdf.bounds.bottom
    end

    pdf.move_down 15

    pdf.font_size previous_size
  end

  def text(txt)
    pdf.text txt, align: :justify, indent_paragraphs: 20
  end

  def image(img)
    pdf.image StringIO.new(img), width: pdf.bounds.width
  end
end