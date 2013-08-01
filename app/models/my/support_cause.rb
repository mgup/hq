class My::SupportCause < ActiveRecord::Base
  self.table_name = 'support_cause'

  alias_attribute :id,           :support_cause_id
  alias_attribute :title,        :support_cause_title
  alias_attribute :pattern,      :support_cause_pattern
  alias_attribute :patternf,     :support_cause_patternf

  has_many :options,  class_name: My::SupportOptions, primary_key: :support_cause_id,
           foreign_key: :support_options_cause

end