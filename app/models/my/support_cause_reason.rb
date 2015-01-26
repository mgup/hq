class My::SupportCauseReason < ActiveRecord::Base
self.table_name = 'support_cause_reason'

alias_attribute :cause,     :support_cause_reason_cause
alias_attribute :reason,    :support_cause_reason_reason

belongs_to :cause, class_name: My::SupportCause, primary_key: :support_cause_id,
           foreign_key: :support_cause_reason_cause
belongs_to :reason, class_name: My::SupportReason, primary_key: :support_reason_id,
           foreign_key: :support_cause_reason_reason

end