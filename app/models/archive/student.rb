class Archive::Student < ActiveRecord::Base
  self.table_name = 'archive_student_group'

  alias_attribute :id,         :archive_student_group_id

  belongs_to :order, class_name: 'Office::Order', primary_key: :order_id, foreign_key: :archive_student_group_order
  belongs_to :student, class_name: 'Student', primary_key: :student_group_id, foreign_key: :student_group_id, primary_key: :student_group_id

end