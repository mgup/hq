class Purchase::GoodsController < ApplicationController
  load_and_authorize_resource

  def index
    @goods = Purchase::Good.all
  end

  def new
    @good = Purchase::Good.new
  end

  def create
    @good = Purchase::Good.new(resource_params)
    if @good.save
      redirect_to new_purchase_purchase_path(@purchase), notice: 'Товар успешно создан!'
    else
      render action: :new
    end
  end

  def edit
    @good = Purchase::Good.find(params[:id])
  end

  def update
    @good = Purchase::Good.find(params[:id])
    if @good.update(resource_params)
      redirect_to purchase_goods_path, notice: 'Товар успешно изменен!'
    else
      render action: :edit
    end
  end

  def destroy
    @good = Purchase::Good.find(params[:id])
    @good.destroy
    redirect_to purchase_goods_path, notice: 'Товар удален'
  end

  def resource_params
    params.fetch(:purchase_good, {}).permit(
      :name, :demand,
      purchase_purchases_attributes: [:id, :dep_id, :number,
                                      :date_registration, :status, :note],
      purchase_line_items_attributes: [:id, :good_id, :purchase_id, :period, :contract_number,
                                       :contract_date,:planned_sum, :supplier_id,:published,
                                       :contracted, :delivered, :paid])
  end
end
