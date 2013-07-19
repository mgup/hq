class Study::Exam < ActiveRecord::Base
  self.table_name = 'exam'

  alias_attribute :id,       :exam_id
  alias_attribute :type,     :exam_type
  alias_attribute :date,     :exam_date
  alias_attribute :weight,   :exam_weight
  alias_attribute :parent,   :exam_parent
  alias_attribute :repeat,   :exam_repeat

  belongs_to :discipline, class_name: Study::Discipline, primary_key: :subject_id, foreign_key: :exam_subject
  belongs_to :group, primary_key: :group_id, foreign_key: :exam_group

  #has_many :exam_students, class_name: Study::ExamStudents, foreign_key: :exam_student_exam
  #has_many :students, :through => :exam_students
  #has_many :exammarks, class_name: Study::Exammark, foreign_key: :mark_exam

end