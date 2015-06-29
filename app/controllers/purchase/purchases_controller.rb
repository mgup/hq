class Purchase::PurchasesController < ApplicationController
  load_and_authorize_resource except: :new

  def index
    @purchases = Purchase::Purchase.all
  end

  def new
    @purchase = Purchase::Purchase.new
  end

  def show
    @purchase = Purchase::Purchase.find(params[:id])
    count_goods
    calculate_stat
    create_report
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
      # raise params.inspect
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

  def count_goods
    @count_goods = Purchase::LineItem.where(:purchase_id => @purchase.id).count('good_id')
    @sum = Purchase::LineItem.where(:purchase_id => @purchase.id).sum('total_price')
  end

  def calculate_stat
    @count_published = Purchase::LineItem.where(:purchase_id => @purchase.id, :published => 'опубликован').count('good_id')
    @count_contracted = Purchase::LineItem.where(:purchase_id => @purchase.id).where(:contracted => 'законтрактирован').count('good_id')
    @count_delivered = Purchase::LineItem.where(:purchase_id => @purchase.id).where(:delivered => 'поставлен').count('good_id')
    @count_paid = Purchase::LineItem.where(:purchase_id => @purchase.id).where(:paid => 'оплачен').count('good_id')
  end
end
