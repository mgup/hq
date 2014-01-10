class Document::DocsController < ApplicationController

  def create
    #raise params.inspect
    doc = params[:document_doc]
    @document = Document::Doc.new document_type: doc[:document_type],
                                  document_number: (Document::Doc.socials.empty? ? 1 : Document::Doc.socials.last.number.to_i + 1 ),
                                  document_expire_date: (doc[:expire_date].blank? ? Date.today.change(year: Date.today.year+100) : doc[:expire_date]), document_start_date: doc[:start_date], document_name: doc[:name],
                                  document_eternal: doc[:eternal], document_department: doc[:department]
    @student  = Student.find(params[:student])
    if @document.save
      @document_person = Document::DocumentPerson.create(@student.person.attributes.merge(document: @document))
      @document_student = Document::DocumentStudent.create(@student.attributes.merge(document: @document))
    end
    redirect_to student_grants_path(@student)
  end

end