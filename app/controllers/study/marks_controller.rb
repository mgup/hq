class Study::MarksController < ApplicationController
  load_and_authorize_resource

  before_filter :find_subject, only: [:index, :new, :create]

  def index ; end

  def new
    case @subject.semester
      when 1
        time = Time.new((@subject.year + 1), 1, 1)
      when 2
        time = Time.new((@subject.year + 1), 6, 1)
    end

    @students = Student.in_group_at_date(@subject.group.id, time)
  end

  def create
    raise params.inspect
    #@mark.session_id = params[:subject_id]
    #if @mark.save
    #  redirect_to new_subject_mark_path(@subject), notice: 'Сохранено'
    #else
    #  render action: :index
    #end
  end

  def edit ; end

  def resource_params
    params.fetch(:mark, {}).permit(:user_id, :student_id, :mark, :retake)
  end

  private

  def find_subject
    @subject = Study::Subject.find(params[:subject_id])
  end
end