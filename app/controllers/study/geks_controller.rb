class Study::GeksController < ApplicationController
  load_and_authorize_resource

  def index
    @geks = @geks.where(study_year: Study::Discipline::CURRENT_STUDY_YEAR)
  end

  def create
    if @gek.save
      redirect_to study_geks_path, notice: 'Секретарь ГЭК успешно добавлен.'
    else
      redirect_to study_geks_path, error: 'ПРОИЗОШЛА ОШИБКА'
    end
  end

  def destroy
    if current_user.is?(:developer)
      @gek.destroy
    end

    redirect_to study_geks_path
  end

  def resource_params
    params.fetch(:study_gek, {}).permit(:position_id, :group_id, :study_year)
  end
end
