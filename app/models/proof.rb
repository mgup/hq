class Proof < ActiveRecord::Base

  enum ref_type: { session_call: 1 }

  belongs_to :student, class_name: 'Student', foreign_key: :student_group_id, primary_key: :student_group_id

end