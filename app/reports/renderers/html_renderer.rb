class Renderers::HtmlRenderer < Renderer
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper

  def title(report)
    content_tag(:div, class: 'page-header') do
      content_tag(:h1) do
        res = [report.title]
        res << '<br>'.html_safe
        res << content_tag(:small, I18n.l(report.generated_at)).html_safe

        res.join.html_safe
      end
    end
  end

  def text(txt)
    content_tag :p, txt
  end

  def image(img)
    image_tag "data:image/png;base64,#{Base64.encode64(img)}",
              class: 'img-responsive'
  end
end