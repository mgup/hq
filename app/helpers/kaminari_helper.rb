module KaminariHelper
  def paginate_with_info(scope)
    paginator = paginate scope
    if scope.total_pages < 2
      info = "<p class='pull-right'><strong>#{scope.size}</strong> из <strong>#{scope.size}</strong></p>"
    else
      info = "<p class='pull-right' style='padding-top: 25px'><strong>#{scope.offset_value + 1} - #{scope.offset_value + scope.length}</strong> из <strong>#{scope.total_count}</strong></p>"
    end
    paginator +  info.html_safe
  end
end