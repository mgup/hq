class Archive::Person < Person
  self.table_name = 'archive_student'

  alias_attribute :id,  :archive_student_id

  belongs_to :order, class_name: 'Office::Order', primary_key: :order_id, foreign_key: :archive_order
  belongs_to :person, class_name: 'Person', primary_key: :student_id, foreign_key: :student_id

end