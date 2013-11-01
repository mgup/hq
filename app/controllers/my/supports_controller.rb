class My::SupportsController < ApplicationController
  load_resource

  before_filter :find_student
  skip_before_filter :authenticate_user!
  before_filter :authenticate_student!
  def index ; end

  def new
    authorize! :manage, Student
  end

  def create
    authorize! :manage,  Student
    @support = My::Support.new(resource_params)
    #@support = My::Support.new student: @student, year: params[:year],
    #                           month: params[:month], series: params[:series],
    #                           number: params[:number], date: params[:date],
    #                           department: params[:department], birthday: params[:birthday],
    #                           address: params[:address], phone: params[:phone]
    if @support.save
      params[:causes].each do |cause|
        option = My::SupportOption.new support: @support, cause: My::SupportCause.find(cause)
        option.save
      end
      redirect_to student_support_my_student_path, notice: 'Успешно создано'
    else
      redirect_to new_my_student_support_path, notice: 'Произошла ошибка'
    end
  end

  def download_pdf
    authorize! :manage, Student
    find_student
    #respond_to do |format|
    #  format.pdf
    #end
  end

  def resource_params
    params.fetch(:my_support, {}).permit(:support_student, :year, :month, :series,
                                         :number, :date, :department, :birthday,
                                         :address, :phone)
  end

  private

  def find_student
    @student = current_student
  end

end
