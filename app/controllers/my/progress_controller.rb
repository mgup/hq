class My::ProgressController < ApplicationController

  def index
    @disciplines = Study::Discipline.from_student(Student.find(17106))
    @subjects = Study::Subject.from_student(Student.find(17106))
    @sessions = []
    @subjects.each do |s|
      @sessions << {year: s.year, semester: s.semester, term: s.term}
    end
    @sessions = @sessions.uniq()
  end

  def discipline
    @discipline = Study::Discipline.find(params[:id])
    @checkpoints = @discipline.checkpoints
  end

  def subject
    @subject = Study::Subject.find(params[:id])
    @subjects = Study::Subject.from_student(Student.find(17106)).where(year: @subject.year, semester: @subject.semester)
  end

end