class MarksController < ApplicationController
  load_and_authorize_resource

  def index 
     @marks=Mark.all
  end

  def new
    @mark=Mark.new
    @session = Session.find(params[:session_id])
    @kind=@session.kind
  end

  def create
    @session = Session.find(params[:session_id])
    @mark.session_id = params[:session_id]
    if @mark.save
      redirect_to new_session_mark_path(@session), notice: 'Сохранено'
    else
      render action: :index
    end
  end

  def edit 
     
  end

  def resource_params
    params.fetch(:mark, {}).permit(:user_id, :student_id, :mark, :retake)
  end
  
end