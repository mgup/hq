class My::ProgressController < ApplicationController

  before_filter :find_student

  def index
    authorize! :index, :myprogress
    @sessions = []
    @subjects.each do |s|
      @sessions << {year: s.year, semester: s.semester, term: s.term}
    end
    @sessions = @sessions.uniq()
  end

  def discipline
    authorize! :show, :myprogress
    @discipline = @disciplines.find(params[:id])
    @checkpoints = @discipline.checkpoints
  end

  def subject
    authorize! :show, :progress
    @subject = @subjects.find(params[:id])
    @subjects = @subjects.where(year: @subject.year, semester: @subject.semester)
                         .sort_by{ |s| [s[:kind]]}
  end

  private

  def find_student
    @student = Student.find(params[:student_id])
    @disciplines = Study::Discipline.from_student(@student)
    @subjects = Study::Subject.from_student(@student)
  end

end