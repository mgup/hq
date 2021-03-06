class Purchase::PurchasesController < ApplicationController
  load_and_authorize_resource
  before_action :set_purchase, only: [:update, :destroy, :edit]

  def budget
    @purchases = Purchase::Purchase.budget
  end

  def off_budget
    @purchases = Purchase::Purchase.off_budget
  end

  def new
    @purchase = Purchase::Purchase.new
  end

  def show
    @purchase = Purchase::Purchase.find(params[:id])
    create_report
    count_goods
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

  end

  def update
    if @purchase.update(resource_params)
      redirect_to purchase_purchases_path, notice: 'Изменения сохранены'
    else
      render action: :edit
    end
  end

  def destroy
    if @purchase.destroy
      redirect_to purchase_purchases_path, notice: 'Заявка удалена'
    end

  end

  def resource_params
    params.fetch(:purchase_purchase, {}).permit(
      :id, :dep_id, :number, :date_registration, :status, :payment_type, :purchase_introduce,
      purchase_line_items_attributes: [:id, :good_id, :purchase_id, :period, :planned_sum,
                                       :published, :contracted, :delivered, :paid, :_destroy] )
  end

  private

  def set_purchase
    @purchase = Purchase::Purchase.find(params[:id])
  end

  def create_report
    respond_to do |format|
      format.html
      format.xlsx
      format.pdf
    end
  end

  def count_goods
    @count_goods = Purchase::LineItem.where(purchase_id: @purchase.id).count('good_id')
  end
end
