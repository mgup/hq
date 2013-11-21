class Study::ExamsController < ApplicationController
  before_filter :load_discipline
  load_and_authorize_resource :discipline
  load_and_authorize_resource through: :discipline, except: :create

  def index ; end

  def new ; end

  def edit ; end

  def show ; end

  def update ; end

  def destroy ; end

  def create
    #raise params.inspect
    exam = params[:study_exam]
    @exam = Study::Exam.create(exam)
    if exam.include?(:exam_group)
      Group.find(exam[:exam_group]).students.each do |s|
       Study::ExamStudent.create person: s.person, student: s, exam: @exam
      end
    end
  end

  def resource_params
    params.fetch(:study_exam, {}).permit( :id, marks_attributes: [:id, :mark_student_group, :mark_value]
    )
  end

  private

  def load_discipline
    @discipline = Study::Discipline.find(params[:discipline_id])
  end
end