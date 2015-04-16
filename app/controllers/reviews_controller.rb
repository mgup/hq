class ReviewsController < ApplicationController

  authorize_resource

  def index
    @reviews = Review.all
    @reviews_page = @reviews.page(params[:page])
    create_report
  end

  def search_results
    #fail params.inspect
    if params[:search_keywords].empty?
      @reviews_found = Review.date_search(params)
    elsif params[:start_date].empty? and params[:end_date].empty?
      @reviews_found = Review.university_search(params)
      if @reviews_found.blank?
        @reviews_found = Review.keyword_search(params)
      end
    else
      @reviews_found = Review.keyword_search(params).date_search(params)
    end
    @reviews_page = @reviews_found # чтобы не создавать новый row
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
    @university = University.all
  end

  def edit
    @review = Review.find(params[:id])
    count_total
  end

  def create
    @review = Review.new(resource_params)
    count_total
    if @review.save
      redirect_to @review
    else
      render 'new'
    end
  end

  def update
    @review = Review.find(params[:id])
    count_total
    if @review.update(resource_params)
      redirect_to @review
    else
      render 'edit'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to reviews_path
  end

  def resource_params
    params.fetch(:review, {}).permit(
        :number_review,
        :date_registration,
        :status,
        :contract_number,
        :contract_date,
        :contract_expires,
        :ordt,
        :author,
        :university_id,
        :title,
        :university_auth_id,
        :cost,
        :total_cost,
        :sheet_number,
        :date_auth_university,
        :evaluation,
        :auth_contract_number,
        :date_auth_contract,
        :date_review,
        :date_accounting,
        :paid,
        :note)
  end

  private

  def count_total
    if @review.sheet_number.nil?
      @review.total_cost = 0
      @review.cost = 0
    else
      @review.total_cost = 614.544 * (@review.sheet_number + 5.28)
      @review.cost = @review.total_cost - 1297.92
    end
    if @review.contract_date.nil?
      @review.contract_date = 0
    else
      @review.contract_expires = l(@review.contract_date + 4.month)
    end
  end

  def create_report
    respond_to do |format|
      format.html
      format.csv
      #format.xls  # { send_data @universities.to_csv(col_sep: "\t") }
      format.xlsx
    end
  end
end