module BootstrapHelper
  def modal_placeholder(modal_id)
    content_tag(:div, id: modal_id, class: 'modal fade', tabindex: '-1', role: 'dialog',
                :'aria-labelledby' => 'myModalLabel', :'aria-hidden' => true ) do
      content_tag(:div, class: 'modal-dialog modal-lg') do
        content_tag(:div, nil, class: 'modal-content')
      end
    end
  end
end