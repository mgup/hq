class Study::Mark < ActiveRecord::Base
  self.table_name = 'study_marks'

  FAIL = 0
  PASS = 1

  belongs_to :subject, :class_name => Study::Subject
  belongs_to :student
  belongs_to :user

  scope :by_student, -> student { where(student_id: student) }

  def test
    case mark
      when FAIL
        'незачёт'
      when PASS
        'зачёт'
    end
  end
end