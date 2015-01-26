class My::SupportReason < ActiveRecord::Base
  self.table_name = 'support_reason'

  alias_attribute :id,           :support_reason_id
  alias_attribute :pattern,      :support_reason_pattern

  has_many :causereasons,  class_name: My::SupportCauseReason, primary_key: :support_reason_id,
           foreign_key: :support_cause_reason_reason
  has_many :causes, through: :causereasons

end