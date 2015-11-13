class Purchase::LineItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_line_item, only: [:new, :show, :update, :destroy, :edit]

  def edit

  end

  def update
    if @lineitem.update(resource_params)
      redirect_to purchase_purchase_path(@lineitem.purchase_purchases), notice: 'Изменения сохранены'
    else
      render action: :edit
    end
  end

  def destroy
    @lineitem.destroy
    redirect_to purchase_purchase_path(@lineitem.purchase_id), notice: 'Товар удален'
  end

  def resource_params
    params.require(:purchase_line_item).permit(
        :id, :good_id, :purchase_id, :period, :planned_sum, :supplier_id,
        :published, :contracted, :delivered, :paid,
        purchase_purchases_attributes: [:id, :dep_id, :number,
                                        :date_registration, :status, :payment_type, :purchase_introduce],
        purchase_goods_attributes: [:id, :name, :demand, :department_id],
        purchase_contract_items_attributes: [:id, :line_item_id, :contract_id, :total_price, :item_count,
                                             :contract_time, :_destroy,
        purchase_contracts_attributes: [:id, :number, :date_registration, :total_price, :_destroy]])
  end

  private

  def set_line_item
    @lineitem = Purchase::LineItem.find(params[:id])
  end

  def user_dep
    @current_user.departments.each do |department|
      if department.subdepartments.any?
        @current_user.departments = department.subdepartments
      end
      department.name
    end
  end
end