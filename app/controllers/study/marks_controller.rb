class Study::MarksController < ApplicationController
  load_and_authorize_resource

  before_filter :find_subject, only: [:index, :new, :create, :edit]

  def index
    disciplines = Study::Subject.where(year: @subject.year).where(semester: @subject.semester).where(group_id: @subject.group_id).where(title: @subject.title).where(kind: @subject.kind)
    @marks = Study::Mark.where(subject_id: disciplines)
    @discipline_students = Array.new
    case @subject.semester
      when 1
        time = Time.new((@subject.year + 1), 1, 1)
      when 2
        time = Time.new((@subject.year + 1), 6, 1)
    end
    @students = Student.in_group_at_date(@subject.group.id, time)
    @students.each do |s|
      m = Array.new
      r = Array.new
      student = Hash.new
      student['id'] = s.id
      student['name'] = s.person.full_name
      student_mark = @marks.where(student_id: s)
      result = Array.new
      retake = Array.new
      student_mark.each do |sm|
        result.insert(-1, sm.mark) 
        retake.insert(-1, sm.retake)
      end 
      result.uniq!
      result.each do |res|
        mark = student_mark.where(mark: res).first
        m.insert(-1, mark)
      end
      student['marks'] = m
      retake.uniq!
      retake.each do |retake|
        mark = student_mark.where(retake: retake).first
        r.insert(-1, mark)
      end
      student['retakes'] = r
      @discipline_students.insert(-1,student)
    end

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
    ver = true
    marks.each do |ex|
      ver= (ex[:mark] != '') && ver
    end

    if ver
      marks.each do |m|
        mark=Study::Mark.new user_id: m[:user_id], subject_id: params[:subject_id], student_id: m[:student_id], mark: m[:mark], retake: m[:retake]
        mark.save!
      end
      redirect_to study_subject_marks_path(@subject), notice: 'Сохранено'
    else
      redirect_to new_study_subject_mark_path(@subject), notice: 'Вы внесли не все результаты!'
    end

  end

  def edit
    disciplines = Study::Subject.where(year: @subject.year).where(semester: @subject.semester).where(group_id: @subject.group_id).where(title: @subject.title).where(kind: @subject.kind)
    descipline_marks = Study::Mark.where(subject_id: disciplines) 
    @student_mark =  descipline_marks.where(student_id: @mark.student.id)
    @this_marks = Array.new
    @student_mark.each do |stud_mark|
      @this_marks.insert(-1,stud_mark.mark)
    end
    @this_marks.uniq!
    @this_retakes = Array.new
    @student_mark.each do |stud_retake|
      @this_retakes.insert(-1,stud_retake.retake)
    end
    @this_retakes.uniq!
    if params[:marks]
      marks = params[:marks]
    ver = true
    marks.each do |ex|
      ver= (ex[:mark] != '') && ver
    end
    if ver
      marks.each do |m|
        mark=Study::Mark.find(m[:id]) 
        mark.update_attributes(user_id: m[:user_id], subject_id: params[:subject_id], student_id: m[:student_id], mark: m[:mark], retake: m[:retake])
      end
      redirect_to study_subject_marks_path(@subject), notice: 'Сохранено'
    else
      redirect_to new_study_subject_mark_path(@subject), notice: 'Вы внесли не все результаты!'
    end
    end
   end

   def update ; end

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