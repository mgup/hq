class Purchase::ContractsController < ApplicationController
  def index
    @contracts = Purchase::Contract.all
  end
  def new
    @contract = Purchase::Contract.new
  end

  def create
    @contract = Purchase::Contract.new(resource_params)
    if @contract.save
      redirect_to purchase_purchases_path, notice: 'Контракт добавлен' # изменить
    else
      render action: :new
    end
  end

  def edit
    @contract = Purchase::Contract.find(params[:id])
  end

  def update
    @contract = Purchase::Contract.find(params[:id])
    if @contract.update(resource_params)
      redirect_to purchase_contracts_path, notice: 'Контракт успешно изменен!'
    else
      render action: :edit
    end
  end

  def destroy
    @contract = Purchase::Contract.find(params[:id])
    if @contract.destroy
      redirect_to purchase_contracts_path, notice: 'Контракт удален!'
    end

  end

  private

  def resource_params
    params.require(:purchase_contract).permit(
        :id, :number, :date_registration, :total_price, :supplier_id,
        purchase_contract_items_attributes: [:id, :line_item_id, :contract_id, :total_price, :item_count,
                                             :contract_time, :_destroy]
    )
  end
end
