class Office::OrderStudent < ActiveRecord::Base
  self.table_name = 'order_student'

  belongs_to :order, class_name: Office::Order, foreign_key: :order_student_order
  belongs_to :student, class_name: Student, foreign_key: :order_student_student_group_id
  belongs_to :person, class_name: Person, foreign_key: :order_student_student

  scope :my_filter, -> filters { where(order_student_student_group_id: Student.my_filter(filters).collect{|x| x.id})
                                .where(order_student_order: Office::Order.my_filter(filters).collect{|x| x.id}) }
end