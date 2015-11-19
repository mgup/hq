class Purchase::SuppliersController < ApplicationController
  load_and_authorize_resource

  def index
    @suppliers = Purchase::Supplier.all
  end

  def new
    @supplier = Purchase::Supplier.new
  end

  def create
    @supplier = Purchase::Supplier.new(resource_params)
    if @supplier.save
      redirect_to purchase_suppliers_path, notice: 'Поставщик успешно создан' # изменить
    else
      render action: :new
    end
  end

  def edit
    @supplier = Purchase::Supplier.find(params[:id])
  end

  def update
    @supplier = Purchase::Supplier.find(params[:id])
    if @supplier.update(resource_params)
      redirect_to purchase_suppliers_path, notice: 'Данные поставщика успешно изменены' # изменить
    else
      render action: :edit
    end
  end

  def destroy
    @supplier = Purchase::Supplier.find(params[:id])
    @supplier.destroy
    redirect_to purchase_suppliers_path, notice: 'Поставщик удален'
  end

  def resource_params
    params.fetch(:purchase_supplier, {}).permit(
        :name,
        :address,
        :inn,
        :phone)
  end
end
