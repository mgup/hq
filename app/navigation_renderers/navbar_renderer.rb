# Генератор горизонтального меню. Реализует создание выпадающих меню
# с помощью синтаксиса Bootstrap.
class NavbarRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    ul_class = options[:is_subnavigation] ? 'dropdown-menu' : 'nav navbar-nav'

    list_content = item_container.items.each_with_object([]) do |item, list|
      list << content_tag(:li, li_content(item), li_options(item))
    end.join

    skip_if_empty? && item_container.empty? ? '' : content_tag(
      :ul, list_content,
      id: item_container.dom_id,
      class: [item_container.dom_class, ul_class].flatten.compact.join(' ')
    )
  end

  def render_sub_navigation_for(item)
    if item.sub_navigation
      item.sub_navigation.render(options.merge(is_subnavigation: true))
    end
  end

  protected

  def tag_for(item)
    if item.url.nil?
      content_tag('span', item.name, link_options_for(item).except(:method))
    else
      link_to(item.name, item.url, link_options_for(item))
    end
  end

  def link_options_for(item)
    special_options = { method: item.method }.reject { |v| v.nil? }
    link_options = item.html_options[:link] || {}
    opts = special_options.merge(link_options)
    opts[:class] = [
      link_options[:class],
      item.selected_class,
      dropdown_link_class(item)
    ].flatten.compact.join(' ')
    opts.delete(:class) if opts[:class].nil? || opts[:class] == ''
    opts
  end

  def dropdown_link_class(item)
    return unless options[:is_subnavigation]
    'dropdown-toggle' if include_sub_navigation?(item)
  end

  def li_options(item)
    li_options = item.html_options.reject { |k, _| k == :link }
    if include_sub_navigation?(item)
      li_options[:class] = [li_options[:class],
                            'dropdown'].flatten.compact.join(' ')
    end

    li_options
  end

  def li_content(item)
    tag_for(item) unless include_sub_navigation?(item)
    tag_for(item) << render_sub_navigation_for(item)
  end
end
