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

    def table(data)
      @result << '<table class="table table-striped">'.html_safe
      @result << '<thead>'.html_safe
      @result << '<tr>'.html_safe
      data[0].each do |d|
        @result << "<th>#{d}</th>".html_safe
      end
      @result << '</tr>'.html_safe
      @result << '</thead>'.html_safe

      data[1..data.size].each do |row|
        @result << '<tr>'.html_safe
        row.each do |d|
          @result << "<td>#{d}</td>".html_safe
        end
        @result << '</tr>'.html_safe
      end

      @result << '</table>'
    end
  end
end
