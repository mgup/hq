class ReviewsController < ApplicationController
  authorize_resource

  def new

  end

  def edit

  end

  def show
    @review = Review.find(params[:id])
  end

  def index
    @reviews = Review.all
    params[:page] ||= 1
    @reviews = @reviews.page(params[:page])

  end

  def resource_params
    params.fetch(:review, {}).permit(
        :number_review,
        :date_registration,
        :contract_number,
        :contract_date,
        :order_type,
        :author,
        :university_id,
        :title,
        :university_auth_id,
        :date_auth_university,
        :evaluation)
  end
end
