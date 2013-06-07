class StudentsController < ApplicationController
  def index
    @students = Student.all.page(1)
  end
end