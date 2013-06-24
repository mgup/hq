class SessionsController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def new ; end

  def show ; end

  def create
    if @session.save
      redirect_to sessions_path, notice: 'Успешно создана.'
    else
      render action: :index
    end
  end

  def resource_params
    params.fetch(:session, {}).permit(:user_id, :year, :semester, :group_id,
                                      :subject, :kind)
  end
end