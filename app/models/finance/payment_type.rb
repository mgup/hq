class Finance::PaymentType < ActiveRecord::Base
  self.table_name = 'finance_payment_type'

  alias_attribute :id,          :finance_payment_type_id
  alias_attribute :year,        :finance_payment_type_year
  alias_attribute :form,        :finance_payment_type_form
  alias_attribute :speciality,  :finance_payment_type_speciality

  has_many :prices, class_name: Finance::Price, primary_key: :finance_payment_type_id,
           foreign_key: :finance_price_payment_type


  scope :from_student, -> student {where(finance_payment_type_form: student.student_group_form,
                                         finance_payment_type_speciality: student.student_group_speciality )}

end