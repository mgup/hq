class Entrance::EduDocument < ActiveRecord::Base
  self.table_name_prefix = 'entrance_'

  belongs_to :entrant, class_name: 'Entrance::Entrant'
  belongs_to :document_type, class_name: 'Entrance::DocumentType'

  def to_nokogiri(application)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.EduDocument do
        xml.send(fis_document_type_tag) do
          add_fis_document_details(application, xml)
        end
      end
    end

    builder.doc
  end

  private

  # Тип тега, которым данный документ задаётся в ФИС.
  def fis_document_type_tag
    case document_type_id
      when 3  then 'SchoolCertificateDocument'
      when 16 then 'SchoolCertificateBasicDocument'
      when 4  then 'HighEduDiplomaDocument'
      when 5  then 'MiddleEduDiplomaDocument'
      when 6  then 'BasicDiplomaDocument'
      when 7  then 'IncomplHighEduDiplomaDocument'
      when 8  then 'AcademicDiplomaDocument'
      when 19 then 'EduCustomDocument'
      else
        raise 'Неизвестный тип документа об образовании.'
    end
  end

  def add_fis_document_details(application, xml)
    xml.OriginalReceived      true
    xml.OriginalReceivedDate  application.created_at.to_date.iso8601
    # xml.OriginalReceived      application.original
    xml.DocumentSeries        entrant.edu_document.series.blank? ? 'б/с' : entrant.edu_document.series
    xml.DocumentNumber        entrant.edu_document.number
    xml.DocumentDate          entrant.edu_document.date.iso8601
    xml.DocumentOrganization  entrant.edu_document.organization
  end
end
