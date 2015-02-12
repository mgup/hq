class ReviewsController < ApplicationController

  def index
    @reviews = Review.all
    params[:page] ||= 1
    @reviews = @reviews.page(params[:page])

  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
  end

  def edit
    @review = Review.find(params[:id])
  end

  def create
    @review = Review.new(resource_params)
    if @review.save
      redirect_to @review
    else
      render 'new'
    end
  end

  def update
    @review = Review.find(params[:id])

    if @review.update(article_params)
      redirect_to @review
    else
      render 'edit'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    redirect_to articles_path
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
