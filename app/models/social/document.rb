class Social::Document < ActiveRecord::Base
  self.table_name = 'social_documents'

  enum status: { actual: 1, archive: 2 }

  belongs_to :person, class_name: 'Person', foreign_key: :student_id, primary_key: :student_id
  belongs_to :type, class_name: 'Social::DocumentType', foreign_key: :social_document_type_id

  scope :actual, -> { where(status: 1) }
  scope :archive, -> { where(status: 2) }

  def eternal?
    expire_date.nil?
  end

  def actual_for_today?
    expire_date ? (expire_date.future? ? true : false) : true
  end

end