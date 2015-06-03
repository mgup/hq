class Purchase::LineItemsController < ApplicationController
  def index
    @lineitems = Purchase::LineItem.all
  end

  def search_result
    @li_found = Purchase::LineItem.keyword_search(params)
    @lineitems = @li_found
  end

  def show
    @lineitem = Purchase::LineItem.find(params[:id])
    @stat = Purchase::LineItem.statistic(@lineitem.good_id, user_dep)
  end

  def destroy
    @lineitem = Purchase::LineItem.find(params[:id])
    @lineitem.destroy
    redirect_to purchase_purchase_path(@lineitem.purchase_id)
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