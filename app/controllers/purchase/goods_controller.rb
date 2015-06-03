class Purchase::GoodsController < ApplicationController
  def index
    @goods = Purchase::Good.all
  end

  def new
    @good = Purchase::Good.new
  end

  def create
    @good = Purchase::Good.new(resource_params)
    if @good.save
      redirect_to purchase_goods_path # изменить
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
      redirect_to purchase_goods_path # изменить
    else
      render action: :edit
    end
  end

  def destroy
    @good = Purchase::Good.find(params[:id])
    @good.destroy
    redirect_to purchase_goods_path
  end

  def resource_params
    params.fetch(:purchase_good, {}).permit(
        :name,
        :demand)
  end
end
