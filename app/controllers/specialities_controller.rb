class SpecialitiesController < ApplicationController
 load_and_authorize_resource

  def index
    @specialities = Speciality.all
  end

  def show ; end

  def new ; end

  def edit ; end

  def create
    if @speciality.save
      redirect_to specialities_path, notice: 'Специальность успешно создана.'
    else
      render action: :new
    end
  end

  def update
    if @speciality.update(resource_params)
      respond_to do |format|
        format.html { redirect_to specialities_path, notice: 'Изменения сохранены.' }
      end


    else
      render action: :edit
    end
  end

  def destroy
    @speciality.destroy

    redirect_to specialities_path
  end

  def resource_params
    params.fetch(:speciality, {}).permit(:name, :code)
  end
end