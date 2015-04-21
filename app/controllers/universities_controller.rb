class UniversitiesController < ApplicationController
  authorize_resource

  def index
    @universities = University.all
    @universities_page = @universities.page(params[:page])
    respond_to do |format|
      format.html
      format.csv
      format.xls
    end
  end

  def show
    @university = University.find(params[:id])
  end

  def new
    @university = University.new
  end

  def edit
    @university = University.find(params[:id])
  end

  def create
    @university = University.new(resource_params)
    if @university.save
      redirect_to universities_path
    else
      render action: :new
    end
  end

  def update
    @university = University.find(params[:id])
    if @university.update(resource_params)
      redirect_to universities_path
    else
      render action: :edit
    end
  end

  def destroy
    @university = University.find(params[:id])
    @university.destroy

    redirect_to universities_path
  end

  def resource_params
    params.fetch(:university, {}).permit(
      :name)
  end
end
