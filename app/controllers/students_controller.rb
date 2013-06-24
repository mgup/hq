class StudentsController < ApplicationController
  load_and_authorize_resource

  def index
    @students = @students.filter(params).page(params[:page])

    #@students = Student.in_group_at_date 35, '2013-02-24'
    #@students = Student.in_group_at_date 547, '2011-02-24'
    #@students = Student.in_group_at_date 959, Time.now
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