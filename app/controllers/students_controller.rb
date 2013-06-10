class StudentsController < ApplicationController
  load_and_authorize_resource

  def index
    @students = @students.filter(params).page(params[:page])
  end

  def show

  end

  def update
    if @student.update(student_params)
      redirect_to @student
    else
      render action: :show
    end
  end

  private

  def student_params
    params.require(:student)
  end
end