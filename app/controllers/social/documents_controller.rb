class Social::DocumentsController < ApplicationController
  load_and_authorize_resource :student
  before_filter :load_deeds, only: :index
  before_filter :load_deed, only: :update

  def index
    authorize! :index, Social::Document
    @documents = @documents.actual
    @document = Social::Document.new
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

  private

  def load_deeds
    @documents = @student.deeds
  end

  def load_deed
    @document = Social::Document.find(params[:id])
  end

  def resource_params
    params.fetch(:social_document, {}).permit(:student_id, :social_document_type_id, :number,
                                              :department, :start_date, :expire_date, :status)
  end

end