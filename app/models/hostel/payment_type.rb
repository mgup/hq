class Finance::PaymentType < ActiveRecord::Base
  self.table_name = 'finance_payment_type'

  alias_attribute :id,          :hostel_payment_type_id
  alias_attribute :name,        :hostel_payment_type_name
  alias_attribute :form,        :finance_payment_type_form

end