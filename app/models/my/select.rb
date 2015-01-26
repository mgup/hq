class My::Select < ActiveRecord::Base
  self.table_name = 'optional_select'

  alias_attribute :student,   :optional_select_student
  alias_attribute :choice,    :optional_select_optional

  belongs_to :choice, class_name: My::Choice, primary_key: :optional_id, foreign_key: :optional_select_optional
  belongs_to :student, class_name: Student, primary_key: :student_group_id, foreign_key: :optional_select_student

end