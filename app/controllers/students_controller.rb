class StudentsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_student, only: [:documents, :study, :grants, :orders, :hostel]

  before_filter :find_faculties, only: :new

  def index
    @students = @students.joins(:group).my_filter(params)

    params[:page] ||= 1
    @students = @students.page(params[:page])
  end

  def show
    @person = @student.person
  end

  def documents
    @reference = Document::Doc.new
    @petition = Document::Doc.new
  end

  def study

  end

  # def grants
  #   @document = Social::Document.new
  # end

  def orders
  end

  def hostel
  end

  def new
    @person = Person.find(params[:person])
    @student = @person.students.build

    # raise @student.inspect
    #     @person.build_fname
    #     @person.build_iname
    #     @person.build_oname
  end

  def create
    if @student.save
      @student.student_group_speciality = @student.speciality
      redirect_to student_path(@student)
    else
      render action: :new
    end
  end

  def update
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
    # raise @student.person.attributes.inspect
    @reference = Document::Doc.create document_type: params[:document_doc][:document_type],
                                      document_number: (Document::Doc.doc_references.last.number.to_i + 1),
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
    @student = Student.valid_for_today.find(params[:id])
    # raise params.inspect
    @petition = Document::Doc.create  document_type: (Document::Doc::TYPE_REFERENCE),
                                      document_number: (Document::Doc.doc_petitions.last.number.to_i + 1),
                                      document_expire_date: Date.today.change(year: Date.today.year+1)
    @document_person = Document::DocumentPerson.create (@student.person.attributes.merge(document: @petition))
    @document_student = Document::DocumentStudent.create (@student.attributes.merge(document: @petition))
    respond_to do |format|
      format.pdf
    end
  end

  def quality
    if params[:faculty] && params[:year_term] != ''
      @students =@students.my_filter(faculty: params[:faculty]).valid_for_today.full_time_study.group_by{|sp| sp.speciality}.group_by{|f, students| f.faculty}
    end
  end

  def resource_params
    params.fetch(:student, {}).permit(:id, :student_group_student, :student_group_group,
                                      :payment, :student_group_status, :state_line, :record, :abit, :abitpoints, :school, :admission_year
    )
  end

  def soccard
    respond_to do |format|
      format.xml do
        render xml: @students.my_filter(form: 101).where('student_group_id NOT IN (24646, 24683)').valid_for_today.to_soccard #FIXME заменить скоуп на soccard
        # render xml: @students.valid_for_today.where('student_group_group NOT IN (430,434,435,436)').my_filter(form: 101).to_soccard #FIXME заменить скоуп на soccard
        # render xml: @students.valid_for_today.where('student_group_group NOT IN (430,434,435,436)').my_filter(form: 101).limit(10).to_soccard #FIXME заменить скоуп на soccard
      end
    end
  end

  def soccard_mistakes
    @students = @students.valid_for_today.where('student_group_group NOT IN (430,434,435,436)').my_filter(form: 101)
  end

  private

  def find_student
    @student = Student.find(params[:student_id])
    @person = @student.person
  end

  def find_faculties
    @faculties = Department.faculties
    unless current_user.is?(:developer) || can?(:work, :all_faculties)
      user_departments = current_user.departments_ids
      @faculties = @faculties.find_all { |f| user_departments.include?(f.id) }
    end
    params[:faculty] ||= @faculties.first.id if @faculties.length < 2
    if params[:faculty].present?
      @faculty = Department.find(params[:faculty])
    end
  end
end
