class Social::Document < ActiveRecord::Base
  self.table_name = 'social_documents'

  enum status: { actual: 1, archive: 2 }
  enum form: { notarius: 1, soc: 2, copy: 3, original: 4 }

  belongs_to :person, class_name: 'Person', foreign_key: :student_id, primary_key: :student_id
  belongs_to :type, class_name: 'Social::DocumentType', foreign_key: :social_document_type_id

  scope :actual, -> { where(status: 1) }
  scope :archive, -> { where(status: 2) }

  scope :till_date, -> date { where('expire_date <= ? OR expire_date IS NULL', Date.parse(date)) }
  scope :after_date, -> date { where('expire_date > ? OR expire_date IS NULL', Date.parse(date)) }
  scope :with_types, -> types { where('social_document_type_id IN (?)', types) }

  scope :with_last_name, -> (last_name) {
    joins(:person).where('last_name_hint LIKE ?', "#{last_name}%")
  }

  scope :find_from_type, -> type_id { where(social_document_type_id: type_id) }

  def eternal?
    expire_date.nil?
  end

  def actual_for_today?
    expire_date ? (expire_date.future? ? true : false) : true
  end
  
  def form_name
    case form
    when 'notarius'
      'нотариально заверенная копия'
    when 'soc'
      'копия, заверенная ЦСПиВР'
    when 'copy'
      'ксерокопия'
    when 'original'
      'оригинал'
    end
  end

end