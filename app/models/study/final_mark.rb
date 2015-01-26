class Study::FinalMark < ActiveRecord::Base
  self.table_name = 'mark_final'

  VALUE_NEYAVKA     = 1
  VALUE_2           = 2
  VALUE_3           = 3
  VALUE_4           = 4
  VALUE_5           = 5
  VALUE_ZACHET      = 6
  VALUE_NEZACHET    = 7
  VALUE_NULL        = 8  # O_o
  VALUE_NEDOPUSCHEN = 9

  alias_attribute :value,     :mark_final_mark

  belongs_to :exam, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :mark_final_exam
  belongs_to :student, class_name: Student, primary_key: :student_group_id, foreign_key: :mark_final_student

  scope :from_year_and_semester, -> year, semester { joins(:exam).joins(exam: :discipline).where('subject.subject_year = ? AND subject.subject_semester = ?', year, semester)}

end