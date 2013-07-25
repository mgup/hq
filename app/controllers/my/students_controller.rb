class My::StudentsController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def show
    @sessions = []
    @student.subjects.each do |s|
      @sessions << {year: s.year, semester: s.semester, term: s.term}
    end
    @sessions = @sessions.uniq()
  end

  def update ; end

  private

  def student_params
    params.require(:students)
  end
end