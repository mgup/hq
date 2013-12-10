class SupportsController < ApplicationController
  load_resource class: 'My::Support', except: [:update]

  authorize_resource class: 'My::Support'

  #before_filter :find_student
  skip_before_filter :authenticate_user!, only: [:new, :create]

  before_filter :authenticate_student!, only: [:new, :create]

  # проблема: нужно и для студентов, и для сотрудников..

  def index ; end

  def new
    authorize! :manage, Student
    find_student
  end

  def edit
    #authorize! :manage, Student
    find_student
  end

  def create
    authorize! :manage,  Student
    @support = My::Support.new(resource_params)
    if @support.save
      params[:causes].each do |cause|
        option = My::SupportOption.new support: @support, cause: My::SupportCause.find(cause)
        option.save
      end
      redirect_to student_student_support_path, notice: 'Успешно создано'
    else
      redirect_to new_student_support_path, notice: 'Произошла ошибка'
    end
  end

  def update
    @support = My::Support.unscoped.find(params[:id])

    if @support.update(resource_params)
      if params[:causes]
        @support.causes = My::SupportCause.find(params[:causes])
        @support.save
      end

      redirect_to social_applications_path
    else
      raise 'Сохранение не удалось.'
    end
  end

  def download_pdf
    find_student
    #respond_to do |format|
    #  format.pdf
    #end
  end

  def resource_params
    params.fetch(:my_support, {}).permit(:support_student, :year, :month, :series,
                                         :number, :date, :department, :birthday,
                                         :address, :phone, :accepted, :deferred)
  end


  private

  def find_student
    @student = Student.find(params[:student_id])
  end

end
