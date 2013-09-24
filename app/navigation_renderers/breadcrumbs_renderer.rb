class BreadcrumbsRenderer < SimpleNavigation::Renderer::Breadcrumbs
  def render(item_container)
    content_tag :ol, items(item_container).join, { class: 'breadcrumb' }
  end

  protected

  def items(item_container)
    item_container.items.inject([]) do |list, item|
      item_name = item.name.sub(' <span class="caret"></span>', '')

      if item.selected?
        if item.selected? && !include_sub_navigation?(item)
          list << content_tag(:li, item_name, class: 'active')
        else
          list << content_tag(:li, link_to(item_name, item.url))
          if include_sub_navigation?(item)
            list.concat items(item.sub_navigation)
          end
        end
      end
      list
    end
  end

  def li_tags(item_container)
    item_container.items.inject([]) do |list, item|
      if item.selected?
        list << tag_for(item)
        if include_sub_navigation?(item)
          list.concat a_tags(item.sub_navigation)
        end
      end
      list
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