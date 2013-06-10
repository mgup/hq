class SpecialityController < ApplicationController
	before_filter do
    params[:speciality] &&= spiciality_params
  end

   before_action :set_speciality, only: [:edit, :update]

  def index
  	@spec=Speciality.all
  end

  def edit
  end

  private
  def set_speciality
    @speciality = Speciality.find params[:id]
  end
 
  def speciality_params
    params.require(:speciality).permit(:code, :name)
  end
end
