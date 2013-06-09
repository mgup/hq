class StudentsController < ApplicationController
  load_and_authorize_resource

  def index
    @students = @students.filter(params)
    @students = @students.page(params[:page])
  end
end