# Генератор хлебных крошек. Реализует создание хлебных крошек
# с помощью синтаксиса Bootstrap.
class BreadcrumbsRenderer < SimpleNavigation::Renderer::Breadcrumbs
  def render(item_container)
    content_tag :ol, items(item_container).join, class: 'breadcrumb'
  end

  protected

  def items(item_container)
    item_container.items.each_with_object([]) do |item, list|
      next unless item.selected?
      item_name = item.name.sub(' <span class="caret"></span>', '')
      if include_sub_navigation?(item)
        list + [content_tag(:li, link_to(item_name, item.url)),
                items(item.sub_navigation)]
      else
        list << content_tag(:li, item_name, class: 'active')
      end
    end
  end

  def li_tags(item_container)
    item_container.items.each_with_object([]) do |item, list|
      next unless item.selected?
      list << tag_for(item)
      list << a_tags(item.sub_navigation) if include_sub_navigation?(item)
    end
  end

  def tag_for(item)
    if suppress_link?(item)
      content_tag('span', item.name, link_options_for(item).except(:method))
    else
      link_to(item.name, item.url, options_for(item))
    end
  end
end
