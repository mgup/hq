class Study::Exam < ActiveRecord::Base
  TYPE_TEST             = 0
  TYPE_GRADED_TEST      = 9
  TYPE_EXAMINATION      = 1

  TYPE_SEMESTER_WORK    = 2
  TYPE_SEMESTER_PROJECT = 3

  TYPE_PRACTICE = 4
  TYPE_DIPLOMA_PRACTICE = 5
  TYPE_FINAL_EXAM = 6
  TYPE_EXAM_COMMISSION_1 = 7
  TYPE_EXAM_COMMISSION_2 = 8

  TYPE_VALIDATION = 10

  FIRST_REPEAT = 2
  SECOND_REPEAT = 3
  COMMISSION_REPEAT = 4
  EARLY_REPEAT = 1
  RESPECTFUL_REPEAT = 5

  EXAMS_TYPES = [
    ['экзамен',                  TYPE_EXAMINATION],
    ['зачёт',                    TYPE_TEST],
    ['дифференцированный зачёт', TYPE_GRADED_TEST],
    ['практика',                 TYPE_PRACTICE],
    ['ГЭК-1',                    TYPE_EXAM_COMMISSION_1],
    ['ГЭК-2',                    TYPE_EXAM_COMMISSION_2],
    ['преддипломная практика', TYPE_DIPLOMA_PRACTICE],
    ['итоговый гос. экзамен', TYPE_FINAL_EXAM]
  ]

  ADDITIONAL_EXAMS_TYPES = [
    ['курсовая работа',          TYPE_SEMESTER_WORK],
    ['курсовой проект',          TYPE_SEMESTER_PROJECT],
    ['текущая аттестация', TYPE_VALIDATION]
  ]

  self.table_name = 'exam'

  alias_attribute :id,       :exam_id
  alias_attribute :type,     :exam_type
  alias_attribute :date,     :exam_date
  alias_attribute :weight,   :exam_weight
  alias_attribute :parent,   :exam_parent
  alias_attribute :repeat,   :exam_repeat

  belongs_to :discipline, class_name: Study::Discipline, primary_key: :subject_id, foreign_key: :exam_subject
  validates :discipline, presence: true

  belongs_to :group, primary_key: :group_id, foreign_key: :exam_group

  belongs_to :student, class_name: 'Student', primary_key: :student_group_id,
             foreign_key: :exam_student_group

  has_many :students, class_name: Study::ExamStudent, foreign_key: :exam_student_exam, dependent: :destroy
  accepts_nested_attributes_for :students, allow_destroy: true
  has_many :marks, class_name: Study::ExamMark, foreign_key: :mark_exam
  has_many :final_marks, -> { where(mark_final: true)}, class_name: Study::ExamMark, foreign_key: :mark_exam
  accepts_nested_attributes_for :final_marks
  has_many :rating_marks, -> { where(mark_rating: true)}, class_name: Study::ExamMark, foreign_key: :mark_exam
  accepts_nested_attributes_for :rating_marks

  # Все ведомости на пересдачу.
  has_many :repeats, class_name: 'Study::Repeat',
           primary_key: :exam_id, foreign_key: :exam_parent

  # Индивидуальные ведомости на пересдачу.
  has_many :personal_repeats, -> { where('exam_group IS NULL') },
           class_name: 'Study::Repeat',
           primary_key: :exam_id, foreign_key: :exam_parent
  accepts_nested_attributes_for :personal_repeats

  # Групповые ведомости на пересдачу.
  has_many :group_repeats, -> { where('exam_group IS NOT NULL') },
           class_name: 'Study::Repeat', foreign_key: :exam_parent
  accepts_nested_attributes_for :group_repeats

  belongs_to :paret_exam, class_name: Study::Exam, primary_key: :exam_id, foreign_key: :exam_parent



  has_one :formreader, class_name: Study::ExamFormreader, foreign_key: :DocNumber

  validates :type, presence: true, inclusion: { in: [0,
                                                     1,
                                                     self::TYPE_SEMESTER_WORK,
                                                     self::TYPE_SEMESTER_PROJECT,
                                                     TYPE_PRACTICE,
                                                     TYPE_DIPLOMA_PRACTICE,
                                                     TYPE_FINAL_EXAM,
                                                     TYPE_EXAM_COMMISSION_1,
                                                     TYPE_EXAM_COMMISSION_2,
                                                     TYPE_VALIDATION,
                                                     9] }
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 20,

                                                     less_than_or_equal_to: 80 }
  scope :by_term, -> year, term {
    joins(:discipline).where(subject: {subject_year: year, subject_semester: term})
  }
  scope :originals, -> { where(exam_parent: nil) }
  #scope :repeats, -> exam {where(exam_parent: exam.id)}
  scope :repeat, -> {where('exam_parent IS NOT NULL')}
  scope :mass, -> {where('exam_group IS NOT NULL')}
  scope :individual, -> {where('exam_student_group IS NOT NULL')}
  scope :by_student, -> student {where(exam_student_group: student.id)}
  scope :finals, -> {where(type: EXAMS_TYPES.collect{|x| x[1]})}
  scope :with_form, -> {joins(:formreader).where('exam_formreader.exam_formreader_parsed IS TRUE')}
  scope :by_group, -> group_id {
    joins(:discipline).where(subject: {subject_group: group_id})
  }
  scope :not_processed, -> {
    joins('LEFT JOIN (SELECT DocNumber FROM `exam_formreader` WHERE `exam_formreader`.exam_formreader_id > 10000 GROUP BY DocNumber) AS `formreader` ON `exam_id` = `formreader`.`DocNumber`')
    .where('`DocNumber` IS NULL and exam_date IS NOT NULL')
  }
  scope :from_faculty, -> faculty_id {
    joins('JOIN `subject` ON `subject`.subject_id = exam_subject
    JOIN `group` ON `group`.group_id = `subject`.subject_group
    JOIN `speciality` ON `speciality`.speciality_id = `group`.group_speciality
    JOIN `department` ON `department`.department_id = `speciality`.speciality_faculty')
    .where('`department`.department_id = ?', faculty_id)
  }

  def is_repeat?
    parent?
  end

  def is_individual_repeat?
    students.length == 1 && parent?
  end

  def is_mass_repeat?
    students.length > 1 && parent?
  end

  def test?
    TYPE_TEST == type
  end

  def graded_test?
    TYPE_GRADED_TEST == type
  end

  def exam?
    TYPE_EXAMINATION == type
  end

  def validation?
    TYPE_VALIDATION == type
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
      when TYPE_PRACTICE
        'практика'
      when TYPE_DIPLOMA_PRACTICE
        'преддипломная практика'
      when TYPE_FINAL_EXAM
        'итоговый гос. экзамен'
      when TYPE_EXAM_COMMISSION_1
        'ГЭК-1'
      when TYPE_EXAM_COMMISSION_2
        'ГЭК-2'
      when TYPE_VALIDATION
        'текущая аттестация'
    end
  end

  def repeat_type
    case repeat
      when FIRST_REPEAT
        'первая пересдача'
      when SECOND_REPEAT
        'вторая пересдача'
      when COMMISSION_REPEAT
        'комиссия'
      when EARLY_REPEAT
        'досрочно'
      when RESPECTFUL_REPEAT
        'уважительная причина'
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

  # Можно ли распечатывать ведомость для данного испытания?
  def can_print_register?
    condition = date? && discipline.subject_teacher? && (User.teachers.include? discipline.lead_teacher)
    if discipline.brs? && (graded_test? || test? || exam? || validation?)
      condition &&= (validation? ? discipline.classes.not_full(discipline).empty? : discipline.classes.not_full_final(discipline).empty?)
    end
    condition
  end
end