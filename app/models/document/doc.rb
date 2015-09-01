class Document::Doc < ActiveRecord::Base
  TYPE_REFERENCE            = 1 # Справка-ходатайство
  TYPE_HOSTEL_CONTRACT      = 2 # Договор найма
  TYPE_REG_REFERENCE        = 3 # Заявление о регистрации
  TYPE_UNIVERSITY_REFERENCE = 4 # Справка о том, что студент учится в университете
  TYPE_CONTRACT             = 5 # Договор студента с университетом
  TYPE_PAYMENT_HOSTEL       = 6 # Справка об оплате за общежитие
  TYPE_SOCIAL_SCHOLARSHIP   = 7 # Справка для получения государственной соц стипендии
  TYPE_DISABLED             = 8 # Справка об инвалидности
  TYPE_RADIATION            = 9 # Удостоверение для ЧАЭС
  TYPE_DEMAND               = 10 # Справка по требованию
  TYPE_TRANSFER_PROTOCOL    = 11 # Протокол заседания комиссии по отчислению, восстановлению и переводу студентов.

  self.table_name = 'document'

  alias_attribute :id,          :document_id
  alias_attribute :type,        :document_type
  alias_attribute :number,      :document_number
  alias_attribute :date,        :document_create_date
  alias_attribute :name,        :document_name
  alias_attribute :department,  :document_department
  alias_attribute :start_date,  :document_start_date
  alias_attribute :expire_date, :document_expire_date
  alias_attribute :eternal,     :document_eternal

  has_many :document_students, class_name: Document::DocumentStudent, primary_key: :document_id,
           foreign_key: :document_student_document
  has_many :students, through: :document_students

  has_many :metas, class_name: Document::Meta, primary_key: :document_id, foreign_key: :document_meta_document

  scope :doc_references, -> { where(document_type: TYPE_UNIVERSITY_REFERENCE) }

  scope :doc_petitions, -> { where(document_type: TYPE_REFERENCE) }

  scope :socials, -> { where(document_type: TYPE_SOCIAL_SCHOLARSHIP) }

  scope :transfer_protocols, -> { where(document_type: TYPE_TRANSFER_PROTOCOL) }

  # Получение имени плательщика по договору.
  def payer
    metas.where(document_meta_pattern: 'Плательщик').first.text if TYPE_CONTRACT == type
  end
end