class Purchase::PurchasesController < ApplicationController
  load_and_authorize_resource except: :new
  before_action :set_purchase, only: [:show, :update, :destroy, :edit]

  def budget
    @purchases = Purchase::Purchase.budget
  end

  def off_budget
    @purchases = Purchase::Purchase.off_budget
  end

  def new
    @purchase = Purchase::Purchase.new
    @good = Purchase::Good.new
  end

  def show
    #raise params.inspect
    count_goods
    calculate_stat
  end

  def create
    if @purchase.payment_type == Purchase::Purchase::PAYMENT_BUDGET && @purchase.save
      redirect_to budget_purchase_purchases_path, notice: 'Заявка создана'
    elsif @purchase.payment_type == Purchase::Purchase::PAYMENT_OFF_BUDGET && @purchase.save
      redirect_to off_budget_purchase_purchases_path, notice: 'Заявка создана'
    else
      render action: :new
    end
  end

  def edit
    @purchase = Purchase::Purchase.find(params[:id])
  end

  def update
    if @purchase.update(resource_params) && @purchase.payment_type == Purchase::Purchase::PAYMENT_BUDGET
      redirect_to budget_purchase_purchases_path, notice: 'Изменения сохранены'# изменить
    elsif @purchase.update(resource_params) && @purchase.payment_type == Purchase::Purchase::PAYMENT_OFF_BUDGET
      redirect_to off_budget_purchase_purchases_path, notice: 'Изменения сохранены'
    else
      render action: :edit
    end
  end

  def destroy
    if @purchase.destroy && @purchase.payment_type == Purchase::Purchase::PAYMENT_BUDGET
      redirect_to budget_purchase_purchases_path, notice: 'Заявка удалена'
    else
      redirect_to off_budget_purchase_purchases_path, notice: 'Заявка удалена'
    end

  end

  def resource_params
    params.require(:purchase_purchase).permit(
      :id, :dep_id, :number, :date_registration, :status, :payment_type, :purchase_introduce,
      purchase_line_items_attributes: [:id, :good_id, :purchase_id, :period, :contract_number,
                                       :contract_date,:planned_sum, :supplier_id,:published,
                                       :contracted, :delivered, :paid],
      purchase_goods_attributes: [:id, :name, :demand])
  end

  private

  def set_purchase
    @purchase = Purchase::Purchase.find(params[:id])
  end

  def create_report
    respond_to do |format|
      format.html
      format.csv
      format.xlsx
    end
  end

  def count_goods
    @count_goods = Purchase::LineItem.where(purchase_id: @purchase.id).count('good_id')
  end

  def calculate_stat
    @count_published = Purchase::LineItem.where(purchase_id: @purchase.id, published: 'опубликован').count('good_id')
    @count_contracted = Purchase::LineItem.where(purchase_id: @purchase.id, contracted: 'законтрактирован').count('good_id')
    @count_delivered = Purchase::LineItem.where(purchase_id: @purchase.id, delivered: 'поставлен').count('good_id')
    @count_paid = Purchase::LineItem.where(purchase_id: @purchase.id, paid: 'оплачен').count('good_id')
  end
end
