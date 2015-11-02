class Purchase::ContractsController < ApplicationController
  load_and_authorize_resource

  private

  def resource_params
    params.require(:purchase_contract).permit(
        purchase_line_items_attributes: [:id, :good_id, :purchase_id, :period, :planned_sum, :supplier_id,
        :published, :contracted, :delivered, :paid],
        purchase_contract_items_attributes: [:id, :line_item_id, :contract_id, :total_price, :item_count,
                                             :contract_time, :_destroy],
        :id, :number, :date_registration, :total_price)
  end
end
