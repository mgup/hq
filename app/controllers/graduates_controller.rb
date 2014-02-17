class GraduatesController < ApplicationController
  load_and_authorize_resource

  def index
    user_departments = current_user.departments_ids

    @graduates = @graduates.find_all do |g|
      user_departments.include?(g.group.speciality.faculty.id)
    end

    @groups = Group.for_graduate.find_all do |g|
      user_departments.include?(g.speciality.faculty.id)
    end
  end

  def create
    if @graduate.save
      redirect_to edit_graduate_path(@graduate),
                  notice: 'Информация о выпуске создана — можно заполнять данные.'
    else
      redirect_to :index, notice: 'Произошла ошибка при создании выпуска!'
    end
  end

  def edit

  end

  def update
    if @graduate.update(resource_params)
      redirect_to graduates_path, notice: 'Информация о выпуске успешно сохранена.'
    else
      redirect_to graduates_path, notice: 'Произошла ошибка при сохранении информации о выпуске!'
    end
  end

  def students
    @students = @graduate.group.students.valid_for_today
  end

  def resource_params
    params.fetch(:graduate, {}).permit(:group_id, :year, :chairman, :secretary,
                                       graduate_subjects_attributes: [
                                           :id, :kind, :name, :hours,
                                           :zet, :_destroy
                                       ])
  end
end
