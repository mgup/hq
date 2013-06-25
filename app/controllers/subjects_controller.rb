class SubjectsController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def new ; end

  def show ; end

  def update ; end

  def create
    if @subject.save
      redirect_to subjects_path, notice: 'Успешно создана.'
    else
      render action: :index
    end
  end

  def resource_params
    params.fetch(:subject, {}).permit(:user_id, :year, :semester, :group_id,
                                      :title, :kind)
  end
end