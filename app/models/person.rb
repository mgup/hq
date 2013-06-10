class Person < ActiveRecord::Base
  include Nameable

  self.table_name = 'student'

  alias_attribute :id, :student_id

  alias_attribute :passport_series,     :student_pseries
  alias_attribute :passport_number,     :student_pnumber
  alias_attribute :passport_date,       :student_pdate
  alias_attribute :passport_department, :student_pdepartment

  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_oname

end