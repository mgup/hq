class My::Support < ActiveRecord::Base
  self.table_name = 'support'

  alias_attribute :id,         :support_id
  alias_attribute :year,       :support_year
  alias_attribute :month,      :support_month
  alias_attribute :series,     :support_pseries
  alias_attribute :number,     :support_pnumber
  alias_attribute :date,       :support_pdate
  alias_attribute :department, :support_pdepartment
  alias_attribute :birthday,   :support_pbirthday
  alias_attribute :address,    :support_paddress
  alias_attribute :phone,      :support_pphone

  belongs_to :student, class_name: Student, primary_key: :student_id,
             foreign_key: :support_student
  has_many :options,  class_name: My::SupportOptions, primary_key: :support_id,
           foreign_key: :support_options_support
end