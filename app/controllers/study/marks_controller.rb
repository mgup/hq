class Study::MarksController < ApplicationController
  load_and_authorize_resource

  before_filter :find_subject, only: [:index, :new, :create]

  def index
    @marks = @subject.marks
  end

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

    marks = params[:marks]
    user= current_user.id
    # marks.each do |m|
    #   if m[:mark] != ''
    #     mark=Study::Mark.new user_id: user, subject_id: params[:subject_id], student_id: m[:student_id], mark: m[:mark], retake: m[:retake]
    #     mark.save
    #   end
    # end

    # redirect_to study_subject_marks_path(@subject)

    ver = true
    marks.each do |ex|
      ver= (ex[:mark] != '') && ver
    end

    if ver
      marks.each do |m|
        mark=Study::Mark.new user_id: user, subject_id: params[:subject_id], student_id: m[:student_id], mark: m[:mark], retake: m[:retake]
        mark.save
      end
      redirect_to study_subject_marks_path(@subject), notice: 'Сохранено'
    else
      redirect_to :back, notice: 'Вы внесли не все результаты!'
    end

    

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

  def find_user
    @user = User.find(params[:current_user.id])
  end
end