module BootstrapHelper
  def modal_placeholder(modal_id, params = {})
    content_tag(:div, id: modal_id, class: 'modal fade', tabindex: '-1', role: 'dialog',
                :'aria-labelledby' => 'myModalLabel', :'aria-hidden' => true ) do
      content_tag(:div, class: "modal-dialog #{params[:size]}") do
        content_tag(:div, class: 'modal-content') do
          yield if block_given?
        end
      end
    end
  end
end