class Test_Mark < ActiveRecord::Base
  self.table_name = 'mark'

  alias_attribute :id,        :mark_id
  alias_attribute :value,     :mark_value
  alias_attribute :rating,    :mark_rating
  alias_attribute :date,      :mark_date
  alias_attribute :final,     :mark_final

  belongs_to :student, primary_key: :student_id, foreign_key: :mark_student_group
  belongs_to :exam, primary_key: :exam_id, foreign_key: :mark_exam

end