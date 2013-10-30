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
    #if @student.update_attributes(resource_params)
    #  redirect_to @student
    #else
    #  render action: :show
    #end
  end

  def reference
    @student = Student.valid_for_today.find(params[i])

    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.require(:students)
  end
end