class Office::OrderStudent < ActiveRecord::Base
  self.table_name = 'order_student'

  belongs_to :order, class_name: Office::Order, foreign_key: :order_student_order
  belongs_to :student, class_name: Student, foreign_key: :order_student_student_group_id
end