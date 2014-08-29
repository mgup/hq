class My::SupportCause < ActiveRecord::Base
  self.table_name = 'support_cause'

  alias_attribute :id,           :support_cause_id
  alias_attribute :title,        :support_cause_title
  alias_attribute :pattern,      :support_cause_pattern
  alias_attribute :patternf,     :support_cause_patternf

  has_many :support_options,  class_name: My::SupportOption, primary_key: :support_cause_id,
           foreign_key: :support_options_cause
  has_many :causereasons,  class_name: My::SupportCauseReason, primary_key: :support_cause_id,
           foreign_key: :support_cause_reason_cause
  has_many :reasons, through: :causereasons

  has_many :cause_document_types, class_name: 'Social::CauseDocumentType', foreign_key: :support_cause_id
  has_many :document_types, through: :cause_document_types
end