class StudentsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_student, only: [:documents, :study, :grants, :orders, :hostel]

  def index
    @students = @students.includes([:person, :group]).filter(params).page(params[:page])

    #@students = Student.in_group_at_date 35, '2013-02-24'
    #@students = Student.in_group_at_date 547, '2011-02-24'
    #@students = Student.in_group_at_date 959, Time.now
  end

  def show
    @person = @student.person
  end

  def documents
    @reference = Document::Doc.new
  end

  def study
  end

  def grants
    @document = Document::Doc.new
  end

  def orders
  end

  def hostel
  end

  def new
    @person = Person.new
    @person.build_fname
    @person.build_iname
    @person.build_oname
  end

  def update
    raise params.inspect
    if params[:student][:ciot_password]
      @student.ciot_password =  params[:student][:ciot_password]
      @student.ciot_login =  params[:student][:ciot_login]
      @student.save
      redirect_to @student
    else
      if @student.update_attributes(resource_params)
        redirect_to @student
      else
        render action: :show
      end
    end
  end

  def reference
    @student = Student.valid_for_today.find(params[:id])
    #raise @student.person.attributes.inspect
    @reference = Document::Doc.create document_type: params[:document_doc][:document_type],
                                      document_number: (Document::Doc.references.last.number.to_i + 1),
                                      document_expire_date: Date.today.change(year: Date.today.year+1)
    @document_person = Document::DocumentPerson.create (@student.person.attributes.merge(document: @reference))
    @document_student = Document::DocumentStudent.create (@student.attributes.merge(document: @reference))
    respond_to do |format|
      format.pdf
    end
  end

  def report

  end

  def petition
    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.fetch(:student, {}).permit(
    )
  end

  private

  def find_student
    @student = Student.find(params[:student_id])
  end
end