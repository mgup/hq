class Finance::Price < ActiveRecord::Base
  self.table_name = 'finance_price'

  alias_attribute :id,          :finance_price_id
  alias_attribute :year,        :finance_price_year
  alias_attribute :semester,    :finance_price_semester
  alias_attribute :sum,         :finance_price_price

  belongs_to :type, class_name: Finance::PaymentType, primary_key: :finance_payment_type_id,
             foreign_key: :finance_price_payment_type

end