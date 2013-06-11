class SpecialitiesController < ApplicationController
  before_filter do
    params[:speciality] &&= speciality_params
  end

  before_action :set_speciality, only: [:edit, :update]

  def index 
    @specialities=Speciality.all
  end

  def edit ; end

  def update
    if @speciality.update(speciality_params)
      redirect_to specialities_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  private

  def set_speciality
    @speciality = Speciality.find params[:id]
  end

  def speciality_params
    params.require(:speciality).permit(:name, :code)
  end
end