class AppointmentsController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def new ; end

  def create
    if @appointment.save
      redirect_to appointments_path, notice: 'Должность успешно создана.'
    else
      render action: :new
    end
  end

  def edit ; end

  def update
    if @appointment.update(resource_params)
      redirect_to appointments_path, notice: 'Изменения сохранены.'
    else
      render action: :edit
    end
  end

  def resource_params
    params.fetch(:appointment, {}).permit(:title)
  end
end
