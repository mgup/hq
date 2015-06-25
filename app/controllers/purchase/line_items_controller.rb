class Purchase::LineItemsController < ApplicationController
  load_and_authorize_resource

  def index
    @lineitems = Purchase::LineItem.all
  end

  def search_result
    @li_found = Purchase::LineItem.keyword_search(params)
    @lineitems = @li_found
  end

  def show
    @lineitem = Purchase::LineItem.find(params[:id])
    @stat = Purchase::LineItem.statistic(@lineitem.good_id)
    #@stat_dep = Purchase::LineItem.stat_dep(@lineitem.good_id, user_dep)
  end

  def edit
    @lineitem = Purchase::LineItem.find(params[:id])
  end

  def update
    @lineitem = Purchase::LineItem.find(params[:id])
    if @lineitem.update(resource_params)
      redirect_to purchase_line_items_path, notice: 'Изменения сохранены'
    else
      render action: :edit
    end
  end

  def destroy
    @lineitem = Purchase::LineItem.find(params[:id])
    @lineitem.destroy
    redirect_to purchase_purchase_path(@lineitem.purchase_id), notice: 'Товар удален'
  end

  def resource_params
    params.require(:purchase_line_item).permit(
        :id, :good_id, :purchase_id, :measure,
        :start_price, :total_price, :count, :period,
        :p_start_date, :p_end_date, :supplier_id,
        :published, :contracted, :delivered, :paid,
        purchase_purchases_attributes: [:id, :dep_id, :number,
                                        :date_registration, :status, :note])
  end

  private

  def user_dep
    @current_user.departments.each do |department|
      if department.subdepartments.any?
        @current_user.departments = department.subdepartments
      end
      department.name
    end
  end
end