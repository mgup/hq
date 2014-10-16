module Renderers
  # Класс для генерации элементов отчётов в формате HTML.
  class HtmlRenderer < Renderer
    include ActionView::Context
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper

    def initialize
      @result = ''
    end

    def title(report)
      @result << content_tag(:div, class: 'page-header') do
        content_tag(:h1) do
          res = [report.title]
          res << '<br>'.html_safe
          res << content_tag(:small, I18n.l(report.generated_at)).html_safe

          res.join.html_safe
        end
      end
    end

    def text(txt)
      @result << content_tag(:p, txt)
    end

    def image(img)
      @result << image_tag("data:image/png;base64,#{Base64.encode64(img)}",
                           class: 'img-responsive')
    end

    def table(data, _options = {})
      @result << '<table class="table table-striped">'.html_safe
      @result << content_tag(:thead) do
        content_tag(:tr, data[0].map { |d| content_tag(:th, d) }.join.html_safe)
      end

      data[1..-1].each do |row|
        @result << content_tag(:tr) do
          row.map { |d| table_cell(d) }.join.html_safe
        end
      end

      @result << '</table>'
    end

    private

    def table_cell(data)
      if data.is_a?(Hash)
        content_tag(:td, data[:content], data)
      else
        content_tag(:td, data)
      end
    end
  end
end
