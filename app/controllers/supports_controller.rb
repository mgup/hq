class SupportsController < ApplicationController
  load_resource class: 'My::Support', except: [:update]

  authorize_resource class: 'My::Support' #, except: [:new, :create, :options, :download_pdf]

  skip_before_filter :authenticate_user!, only: [:new, :create, :options, :index, :download_pdf]
  #
  #before_filter :authenticate_student!, only: [:new, :create, :options]

  # проблема: нужно и для студентов, и для сотрудников..

  def index
    @faculties = Department.faculties
  end

  def new
    #authorize! :manage, Student
    @support = My::Support.new
    find_student
  end

  def options
    #authorize! :manage, Student
    find_student
    causes = My::SupportCause.find(params[:causes].split(','))
    reasons = []
    # documents = []
    # @can_print = true
    causes.each do |c|
      reasons << c.reasons.collect{|r| r.id}
      # c.document_types.each do |dt|
      #   d = @student.person.deeds.actual.find_from_type(dt).collect{|x| x.id}
      #   @can_print &&= !d.empty?
      #   documents << d
      # end
    end
    # @documents = Social::Document.find(documents.flatten.uniq)
    @reasons = My::SupportReason.find(reasons)
    respond_to do |format|
      format.js
    end
  end

  def edit
    #authorize! :manage, Student
    find_student
  end

  def create
    #authorize! :manage,  Student
    find_student
    @support = My::Support.new(resource_params)
    if @support.save
      params[:causes].each do |cause|
        option = My::SupportOption.new support: @support, cause: My::SupportCause.find(cause)
        option.save
      end
      redirect_to student_support_student_support_path(@student, @support), notice: 'Успешно создано'
    else
      redirect_to new_student_support_path(@student), notice: 'Произошла ошибка'
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
  end

  def resource_params
    if params[:my_support]
      if params[:my_support][:accepted] == '1'
        params[:my_support][:deferred] = false
      end
    end
    #raise params[:my_support].inspect
    params.fetch(:my_support, {}).permit(:support_student, :year, :month, :series,
                                         :number, :date, :department, :birthday,
                                         :address, :phone, :accepted, :deferred)
  end


  private

  def find_student
    @student = Student.find(params[:student_id])
  end

end
