class Archive::Student < Student
  self.table_name = 'archive_student_group'
  
  alias_attribute :id,         :archive_student_group_id
  
  belongs_to :order, class_name: 'Office::Order', primary_key: :order_id, foreign_key: :archive_student_group_order
  #belongs_to :person, ->(s) { where "archive_student_group_order = ?", s.archive_order }, class_name: 'Archive::Person', primary_key: :student_id, foreign_key: :student_group_student
  belongs_to :student, class_name: 'Student', primary_key: :student_group_id, foreign_key: :student_group_id
  
  def person
    Archive::Person.where(student_id: student_group_student).where(archive_order: archive_student_group_order).last
  end

end