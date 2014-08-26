class Social::DocumentsController < ApplicationController
  load_and_authorize_resource :person
  load_and_authorize_resource through: :person

  before_filter :load_student

  def index
    @document = Social::Document.new
  end

  def create
    #raise params.inspect
    @document = Social::Document.create resource_params
    if @document.save
      redirect_to student_documents_path(@person)
    else

    end
  end

  private

  def load_student
    @student = @person.students.first
  end

end