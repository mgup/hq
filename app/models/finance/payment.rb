class Finance::Payment < ActiveRecord::Base
  self.table_name = 'finance_payment'

  alias_attribute :id,         :finance_payment_id
  alias_attribute :date,       :finance_payment_date
  alias_attribute :sum,        :finance_payment_sum

  #belongs_to :payment_type, class_name: Finance::PaymentType, primary_key: :finance_payment_type_id,
  #           foreign_key: :finance_payment_type

  belongs_to :student, primary_key: :student_id, foreign_key: :finance_payment_student_group

end