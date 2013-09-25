class Office::OrdersController < ApplicationController
  load_and_authorize_resource

  def index
    @orders = @orders.page(params[:page])
  end

  def drafts
    @drafts = Office::Order.drafts
  end

  def underways
    @underways = Office::Order.underways
  end

  def show
    respond_to do |format|
      format.xml { render xml: @order.to_xml }
    end
  end

  def new ; end

  def create
    if @order.save
      redirect_to orders_path, notice: 'Проект приказа успешно создан.'
    else
      render action: :new
    end
  end

  def edit ; end

  def update
    if @order.update(resource_params)
      redirect_to orders_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy
    @order.destroy

    redirect_to roles_path
  end

  def resource_params
    params.fetch(:order, {}).permit()
  end
end