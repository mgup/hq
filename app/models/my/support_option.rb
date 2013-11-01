class My::SupportOption < ActiveRecord::Base
  self.table_name = 'support_options'

  alias_attribute :id,           :support_options_id

  belongs_to :support, class_name: My::Support, primary_key: :support_id,
             foreign_key: :support_options_support
  belongs_to :cause, class_name: My::SupportCause, primary_key: :support_cause_id,
             foreign_key: :support_options_cause

end