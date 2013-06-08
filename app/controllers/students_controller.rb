class StudentsController < ApplicationController
  def index
    @students = Student.all.page(params[:page])
  end
end