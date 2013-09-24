class Office::OrderTemplatesController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def edit ; end

  def update
    if @order_template.update(resource_params)
      redirect_to office_order_templates_path, notice: 'Изменения в шаблоне приказа сохранены.'
    else
      render action: :edit
    end
  end

  def resource_params
    params.fetch(:office_order_template, {}).permit(:template_name)
  end
end