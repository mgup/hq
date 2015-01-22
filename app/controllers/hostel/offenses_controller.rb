class Hostel::OffensesController < ApplicationController
  load_and_authorize_resource class_name: Hostel::Offense

  def index
  end

  def new
  end

  def create
    if @offense.save
      redirect_to hostel_offenses_path, notice: 'Запись успешно создана.'
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @offense.update(resource_params)
      redirect_to hostel_offenses_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def destroy
    @offense.destroy
    redirect_to hostel_offenses_path
  end

  def resource_params
    params.fetch(:hostel_offense, {}).permit(:description, :kind)
  end
end