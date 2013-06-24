class Session::MarksController < ApplicationController
  load_and_authorize_resource

  before_filter :find_session, only: [:index, :new, :create]

  def index ; end

  def new
    case @session.semester
      when 1
        time = Time.new((@session.year + 1), 1, 1)
      when 2
        time = Time.new((@session.year + 1), 6, 1)
    end

    @students = Student.in_group_at_date(@session.group.id, time)
  end

  def create
    raise params.inspect
    #@mark.session_id = params[:session_id]
    #if @mark.save
    #  redirect_to new_session_mark_path(@session), notice: 'Сохранено'
    #else
    #  render action: :index
    #end
  end

  def edit ; end

  def resource_params
    params.fetch(:mark, {}).permit(:user_id, :student_id, :mark, :retake)
  end

  private

  def find_session
    @session = Session.find(params[:session_id])
  end
end