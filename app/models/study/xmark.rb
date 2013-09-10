class Study::Xmark < ActiveRecord::Base
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
        {mark: 'незачёт', strip: '20%', itog: 'danger'}
      when PASS
        {mark: 'зачёт', strip: '100%', itog: 'success'}
      when BAD
        {mark: 'неудовлетворительно', strip: '20%', itog: 'danger'}
      when FAIR
        {mark: 'удовлетворительно', strip: '50%', itog: 'warning'}
      when GOOD
        {mark: 'хорошо', strip: '80%', itog: 'info'}
      when EX
        {mark: 'отлично', strip: '100%', itog: 'success'}
    end
  end

end