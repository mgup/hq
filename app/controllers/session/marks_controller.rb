class SessionMarksController < ApplicationController
  load_and_authorize_resource

  def index 
     
  end

  def new
    @session_mark=SessionMark.new
    @session = Session.find(params[:session_id])
    @kind=@session.kind
  end

  def create
    @session = Session.find(params[:session_id])
    if @session_mark.save
      redirect_to new_session_session_mark_path(@session), notice: 'Сохранено'
    else
      render action: :index
    end
  end

  def resource_params
    params.fetch(:session_mark, {}).permit(:user_id, :student_id, :mark, :retake)
  end
  
end