class Study::ExamsController < ApplicationController
  before_filter :load_discipline
  load_and_authorize_resource :discipline
  load_and_authorize_resource through: :discipline, except: :create

  def index ; end

  def new ; end

  def edit ; end

  def show ; end

  def update
    raise resource_params.inspect
    if @exam.save
      redirect_to study_discipline_checkpoints_path(@discipline)
    end
  end

  def destroy ; end

  def create
    exam = params[:study_exam]
    if exam.include?(:exam_group)
      @exam = Study::Exam.create exam_subject: exam[:exam_subject], parent: exam[:parent], exam_type: exam[:exam_type],
                                 weight: exam[:exam_weight], exam_group: exam[:exam_group], repeat: exam[:repeat], date: exam[:date]
      Group.find(exam[:exam_group]).students.each do |s|
       Study::ExamStudent.create person: s.person, student: s, exam: @exam
      end
    elsif exam.include?(:exam_student_group)
      @exam = Study::Exam.create exam_subject: exam[:exam_subject], parent: exam[:parent], exam_type: exam[:exam_type],
                                 weight: exam[:weight], exam_student: exam[:exam_student], exam_student_group: exam[:exam_student_group],
                                 repeat: exam[:repeat], date: exam[:date]
    end
  end

  def print
    @exam = Study::Exam.find(params[:exam_id])
    load_discipline
    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.fetch(:study_exam, {}).permit( :id, final_marks_attributes: [:id, :mark_student_group, :mark_value, :mark_final],
                                          rating_marks_attributes: [:id, :mark_student_group, :mark_value, :mark_rating]
    )
  end

  private

  def load_discipline
    @discipline = Study::Discipline.find(params[:discipline_id])
  end
end