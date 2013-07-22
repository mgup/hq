class Study::Mark < ActiveRecord::Base
  self.table_name = 'study_marks'

  FAIL = 0
  PASS = 1
  EX = 5
  GOOD = 4
  FAIR = 3
  BAD = 2

  belongs_to :subject, :class_name => Study::Subject
  belongs_to :student
  belongs_to :user

  scope :by_student, -> student { where(student_id: student) }
  scope :by_subject, -> subject { where(subject_id: subject) }

  def test
    case mark
      when FAIL
        'незачёт'
      when PASS
        'зачёт'
      when BAD
        'неудовлетворительно'
      when FAIR
        'удовлетворительно'
      when GOOD
        'хорошо'
      when EX
        'отлично'
    end
  end

  def strip
    case mark
      when FAIL
        '20%'
      when PASS
        '100%'
      when BAD
        '20%'
      when FAIR
        '50%'
      when GOOD
        '80%'
      when EX
        '100%'
    end
  end

  def itog
    case mark
      when FAIL
        'danger'
      when PASS
        'success'
      when BAD
        'danger'
      when FAIR
        'warning'
      when GOOD
        'success'
      when EX
        'success'
    end
  end
end