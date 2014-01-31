class Study::Exam < ActiveRecord::Base
  TYPE_TEST             = 0
  TYPE_GRADED_TEST      = 9
  TYPE_EXAMINATION      = 1

  TYPE_SEMESTER_WORK    = 2
  TYPE_SEMESTER_PROJECT = 3

  FIRST_REPEAT = 2
  SECOND_REPEAT = 3
  COMMISSION_REPEAT = 4
  EARLY_REPEAT = 1
  RESPECTFUL_REPEAT = 5

  self.table_name = 'exam'

  alias_attribute :id,       :exam_id
  alias_attribute :type,     :exam_type
  alias_attribute :date,     :exam_date
  alias_attribute :weight,   :exam_weight
  alias_attribute :parent,   :exam_parent
  alias_attribute :repeat,   :exam_repeat

  belongs_to :discipline, class_name: Study::Discipline, primary_key: :subject_id, foreign_key: :exam_subject
  belongs_to :group, primary_key: :group_id, foreign_key: :exam_group
  belongs_to :student, primary_key: :student_group_id, foreign_key: :exam_student_group
  has_many :marks, class_name: Study::ExamMark, foreign_key: :mark_exam
  has_many :final_marks, -> { where(mark_final: true)}, class_name: Study::ExamMark, foreign_key: :mark_exam
  accepts_nested_attributes_for :final_marks
  has_many :rating_marks, -> { where(mark_rating: true)}, class_name: Study::ExamMark, foreign_key: :mark_exam
  accepts_nested_attributes_for :rating_marks

  validates :type, presence: true, inclusion: { in: [0,
                                                     1,
                                                     self::TYPE_SEMESTER_WORK,
                                                     self::TYPE_SEMESTER_PROJECT,
                                                     9] }
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 20,
                                                     less_than_or_equal_to: 80 }

  scope :originals, -> {where(exam_parent: nil)}
  scope :repeats, -> exam {where(exam_parent: exam.id)}
  scope :mass, -> {where(exam_student_group: nil)}
  scope :individual, -> {where('exam_student_group IS NOT NULL')}
  scope :by_student, -> student {where(exam_student_group: student.id)}
  def test?
    TYPE_TEST == type
  end

  def exam?
    TYPE_EXAMINATION == type
  end

  def name
    case type
      when TYPE_TEST
        'зачёт'
      when TYPE_GRADED_TEST
        'дифференцированный зачёт'
      when TYPE_EXAMINATION
        'экзамен'
      when TYPE_SEMESTER_WORK
        'курсовая работа'
      when TYPE_SEMESTER_PROJECT
        'курсовой проект'
    end
  end

  def repeat_type
    case repeat
      when FIRST_REPEAT
        'Первичный'
      when SECOND_REPEAT
        'Повторный'
      when COMMISSION_REPEAT
        'Комиссия'
      when EARLY_REPEAT
        'Досрочный'
      when RESPECTFUL_REPEAT
        'Уважительная'
    end
  end

  def predication(mark, ball)
    eweight = weight/100.0
    sweight = 1.0 - eweight

    case mark
      when 2
        min = 0
        max = ((55.0 - sweight * ball) / eweight)
        if max == max.round
          max-=1
        end
        max = max.floor
        if max <= 55
          max = 54
        elsif max > 100
          max = 100
        end
      when 3
        max = ((70.0 - sweight * ball) / eweight)
        min = ((55.0 - sweight * ball) / eweight).ceil
        if max == max.round
          max-=1
        end
        max = max.floor
        if max > 100
          max = 100
        elsif max < 55
          min = nil
          max = nil
        end
        if max
          if min > 100
            min = nil
            max = nil
          elsif min < 55
            min = 55
          end
        end
      when 4
        max = ((85.0 - sweight * ball) / eweight)
        min = ((70.0 - sweight * ball) / eweight).ceil
        if max == max.round
          max-=1
        end
        max = max.floor
        max = 100 if max > 100
        if min < 55
          min = 55
          if min > max
            min = nil
            max = nil
          end
        elsif min > 100
          min = nil
          max = nil
        end
      when 5
        min = ((85.0 - sweight * ball) / eweight).ceil
        if min > 100
          min = nil
          max = nil
        else
          max = 100
          if min < 55
            min = 55
          end
        end
    end
    return {max: max, min: min}
  end
end