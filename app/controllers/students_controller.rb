class StudentsController < ApplicationController
  load_and_authorize_resource

  def index
    @students = @students.includes([:person, :group]).filter(params).page(params[:page])

    #@students = Student.in_group_at_date 35, '2013-02-24'
    #@students = Student.in_group_at_date 547, '2011-02-24'
    #@students = Student.in_group_at_date 959, Time.now
  end

  def show

  end

  def new

  end

  def update
    if params[:student][:ciot_password]
      @student.ciot_password =  params[:student][:ciot_password]
      @student.ciot_login =  params[:student][:ciot_login]
      @student.save
      redirect_to @student
    end
    #if @student.update_attributes(student_params)
    #  redirect_to @student
    #else
    #  render action: :show
    #end
  end

  def reference
    authorize! :manage, :student
    find_student
  end

  private

  def student_params
    params.require(:students)

  end

  def find_student
    @student = Student.find(params[:id])
  end
end