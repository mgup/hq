class Study::XMarksController < ApplicationController
  load_and_authorize_resource

  before_filter :find_subject

  def index
    @marks = @marks.by_subject(Study::Subject.find_subjects(@subject))
    @subject_students = []
    @students.each do |student|
      student_marks = @marks.by_student(student)
      result = []
      retake = []
      student_marks.each do |sm|
        result << (@subject.test? ? sm.test : sm.mark)
        retake << ((sm.retake == 0) ? 'нет' : sm.retake)
      end
      result = result.uniq
      retake = retake.uniq
      error = 'danger' if result.size > 1 || retake.size > 1
      @subject_students.push({students: student, marks: result.join(', '),
                              retakes: retake.join(', '),
                              mark: student_marks.first, error: error})
    end

  end

  def new ; end

  def create
    marks = params[:marks]
    ver = true
    marks.each do |ex|
      ver= (ex[:mark] != '') && ver
    end

    if ver
      marks.each do |m|
        mark=Study::Mark.new(m)
        mark.save!
      end
      redirect_to study_subject_marks_path(@subject), notice: 'Сохранено'
    else
      redirect_to new_study_subject_mark_path(@subject),
      notice: 'Вы внесли не все результаты!'
    end

  end

  def edit
    @marks = Study::Mark.by_subject(Study::Subject.find_subjects(@subject))
                        .by_student(@mark.student)
    @marks = @marks.where(user_id: current_user.id) if current_user.is?(:typer)
    result, retake = [], []
    @marks.each do |student_mark|
      result << student_mark.mark
      retake << student_mark.retake
    end
    @results = {marks: result.uniq, retakes: retake.uniq}
   end

  def update
    marks = params[:marks]
    marks.each do |m|
      mark=Study::Mark.find(m[:id])
      mark.update_attributes(m)
    end
    redirect_to study_subject_marks_path(@subject), notice: 'Сохранено'
  end

  def show ; end

  def resource_params
    params.fetch(:mark, {}).permit(:user_id, :student_id, :mark, :retake)
  end

  private

  def find_subject
    @subject = Study::Subject.find(params[:subject_id])
    @students = Student.in_group_at_date( @subject.group.id,
      Time.new((@subject.year + 1), (@subject.in_fall? ? 1 : 6), 1))
  end

end