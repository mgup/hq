class Exam < ActiveRecord::Base
  self.table_name = 'exam'

  alias_attribute :id,       :exam_id
  alias_attribute :type,     :exam_type
  alias_attribute :date,     :exam_date
  alias_attribute :weight,   :exam_weight
  alias_attribute :parent,   :exam_parent
  alias_attribute :repeat,   :exam_repeat

  belongs_to :subject, primary_key: :subject_id, foreign_key: :exam_subject
  belongs_to :group, primary_key: :group_id, foreign_key: :exam_group
  belongs_to :student, primary_key: :student_id, foreign_key: :exam_student_group

  has_many :exam_students, foreign_key: :exam_student_exam
  has_many :marks, foreign_key: :mark_exam
end