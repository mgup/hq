class SidebarRenderer < SimpleNavigation::Renderer::List
  def tag_for(item)
    if suppress_link?(item)
      content_tag 'span', item.name, link_options_for(item).except(:method)
    else
      tags = []
      if item.selected?
        tags << %q{
          <div class="pointer">
            <div class="arrow"></div>
            <div class="arrow_border"></div>
          </div>
        }
      end
      tags << link_to(item.name, item.url, options_for(item))
      tags.join
    end
  end
end
