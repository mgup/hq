class Office::OrderTemplatesController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def edit ; end

  def update
    if @order_template.update(resource_params)
      redirect_to edit_office_order_template_path(@order_template), notice: 'Изменения в шаблоне приказа сохранены.'
    else
      render action: :edit
    end
  end

  def resource_params
    params.fetch(:office_order_template, {}).permit(
        :template_name,
        xsl_attributes: [:order_xsl_template, :order_xsl_content]
    )
  end
end