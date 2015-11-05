class Purchase::ContractsController < ApplicationController
  def new
    @contract = Purchase::Contract.new
  end

  def create
    if @contract.save
      redirect_to purchase_contracts_path
    end

  end

  private

  def resource_params
    params.require(:purchase_contract).permit(
        :id, :number, :date_registration, :total_price,
        purchase_contract_items_attributes: [:id, :line_item_id, :contract_id, :total_price, :item_count,
                                             :contract_time, :_destroy]
    )
  end
end
