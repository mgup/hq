class Social::DocumentsController < ApplicationController
  load_and_authorize_resource :student, except: :list
  before_filter :load_deeds, only: :index
  before_filter :load_deed, only: [:update, :destroy]

  def index
    authorize! :index, Social::Document
    @archive = @documents.archive
    @documents = @documents.actual
    @document = Social::Document.new
  end

  def list
    authorize! :index, Social::Document
    @documents = Social::Document.all

    unless params[:actual] || params[:archive]
      params[:actual] = '1'
      params[:archive] = '1'
    end

    if params[:date] && params[:date] != ''
      @documents = @documents.after_date(params[:date])
    end

    if params[:pdate] && params[:pdate] != ''
      @documents = @documents.till_date(params[:pdate])
    end

    if params[:actual]
      unless params[:archive]
        @documents = @documents.actual
      end
    else
      if params[:archive]
        @documents = @documents.archive
      else
        @documents = []
      end
    end

    params[:types] ||= []

    unless params[:types].empty? || params[:types] == ['']
      @documents = @documents.with_types(params[:types])
    end

    if params[:last_name] && params[:last_name]!=''
      @documents = @documents.with_last_name(params[:last_name])
    end

    respond_to do |format|
      format.html
      format.xlsx
    end

  end

  def create
    authorize! :create, Social::Document
    @document = Social::Document.create resource_params
    @document.save
    redirect_to student_social_deeds_path(@student)
  end

  def update
    authorize! :manage, Social::Document
    @document.update resource_params
    @document.save
    redirect_to student_social_deeds_path(@student)
  end
  
  def destroy
    authorize! :delete, Social::Document
    @document.destroy
    redirect_to student_social_deeds_path(@student)
  end

  private

  def load_deeds
    @documents = @student.deeds
  end

  def load_deed
    @document = Social::Document.find(params[:id])
  end

  def resource_params
    params.fetch(:social_document, {}).permit(:student_id, :social_document_type_id, :number,
                                              :department, :start_date, :expire_date, :status, :comment, :form)
  end

end