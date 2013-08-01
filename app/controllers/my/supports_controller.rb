class My::SupportsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_student

  def index ; end

  def new ; end

  def create
    @support = My::Support.new student: Student.find(params[:student]), year: params[:year],
                               month: params[:month], series: params[:series],
                               number: params[:number], date: params[:date],
                               department: params[:department], birthday: params[:birthday],
                               address: params[:address], phone: params[:phone]
    if @support.save
      params[:causes].each do |cause|
        option = My::SupportOptions.new support: @support, cause: My::SupportCause.find(cause)
        option.save
      end
      redirect_to my_student_path(@student), notice: 'Успешно создано'
    else
       redirect_to new_my_student_support_path(@student), notice: 'Произошла ошибка'
    end
  end


  private

  def find_student
    @student = Student.find(params[:student_id])
  end

  def resource_params
    params.fetch(:supports, {}).permit(:student, :year, :month, :series,
                :number, :date, :department, :birthday, :address, :phone)
  end

end