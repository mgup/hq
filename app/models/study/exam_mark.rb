class Study::ExamMark < ActiveRecord::Base
  self.table_name = 'mark'

  VALUE_NEYAVKA     = 1
  VALUE_2           = 2
  VALUE_3           = 3
  VALUE_4           = 4
  VALUE_5           = 5
  VALUE_ZACHET      = 6
  VALUE_NEZACHET    = 7
  VALUE_NULL        = 8  # O_o
  VALUE_NEDOPUSCHEN = 9

  alias_attribute :id,        :mark_id
  alias_attribute :value,     :mark_value

  belongs_to :exam, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :mark_exam

  scope :by_student, -> student { where(mark_student_group: student) }
  scope :from_year_and_semester, -> year, semester { joins(:exam).joins(exam: :discipline).where('subject.subject_year = ? AND subject.subject_semester = ?', year, semester)}
  def result
    case value
      when VALUE_NEYAVKA
        'неявка'
      when VALUE_2
        'неуд.'
      when VALUE_3
        'удовл.'
      when VALUE_4
        'хорошо'
      when VALUE_5
        'отлично'
      when VALUE_ZACHET
        'зачтено'
      when  VALUE_NEZACHET
        'не зачтено'
      when VALUE_NEDOPUSCHEN
        'недопущен'
    end
  end

  def long_result
    case value
      when VALUE_NEYAVKA
        {mark: 'неявка', span: 'danger'}
      when VALUE_2
        {mark: 'неуд.', span: 'danger'}
      when VALUE_3
        {mark: 'удовл.', span: 'warning'}
      when VALUE_4
        {mark: 'хорошо', span: 'info'}
      when VALUE_5
        {mark: 'отлично', span: 'success'}
      when VALUE_ZACHET
        {mark: 'зачтено', span: 'success'}
      when  VALUE_NEZACHET
        {mark: 'не зачтено', span: 'danger'}
      when VALUE_NEDOPUSCHEN
        {mark: 'недопущен', span: 'danger'}
    end
  end

end