class Purchase::PurchasesController < ApplicationController
  def index
    @purchases = Purchase::Purchase.all
  end

  def new
    @purchase = Purchase::Purchase.new
  end

  def show
    @purchase = Purchase::Purchase.find(params[:id])
    @sum = Purchase::LineItem.where(:purchase_id => @purchase.id).sum('total_price')
    @count_goods = Purchase::LineItem.where(:purchase_id => @purchase.id).count('good_id')
    # fail params.inspect
    create_report
    @departments = Department.all
  end

  def create
    @purchase = Purchase::Purchase.new(resource_params)
    if @purchase.save
      redirect_to purchase_purchases_path, notice: 'Заявка создана'# изменить
    else
      render action: :new
    end
  end

  def edit
    @purchase = Purchase::Purchase.find(params[:id])
  end

  def update
    @purchase = Purchase::Purchase.find(params[:id])
    if @purchase.update(resource_params)
      redirect_to purchase_purchases_path, notice: 'Изменения сохранены'# изменить
    else
      render action: :edit
    end
  end

  def destroy
    @purchase = Purchase::Purchase.find(params[:id])
    @purchase.destroy
    redirect_to purchase_purchases_path, notice: 'Заявка удалена'
  end

  def resource_params
    params.require(:purchase_purchase).permit(
      :id, :dep_id, :number, :date_registration, :status, :note,
      purchase_line_items_attributes: [:id, :good_id, :purchase_id, :measure,
      :start_price, :total_price, :count, :period,
      :p_start_date, :p_end_date, :supplier_id,
      :published, :contracted, :delivered, :paid])
  end

  private

  def create_report
    respond_to do |format|
      format.html
      format.csv
      format.xlsx
    end
  end
end
