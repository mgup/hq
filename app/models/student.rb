class Student < ActiveRecord::Base
  include Nameable

  self.table_name = 'student'

  alias_attribute :id,  :student_id

  belongs_to :fname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_fname
  belongs_to :iname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_iname
  belongs_to :oname, class_name: Dictionary, primary_key: :dictionary_id, foreign_key: :student_oname

  default_scope do
    joins(:fname, :iname, :oname).order('dictionary.dictionary_ip, inames_student.dictionary_ip, onames_student.dictionary_ip')
  end
end