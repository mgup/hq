class Study::Discipline < ActiveRecord::Base
  CURRENT_STUDY_YEAR  = 2015
  CURRENT_STUDY_TERM  = 1

  self.table_name = 'subject'

  alias_attribute :id,       :subject_id
  alias_attribute :name,     :subject_name
  alias_attribute :semester, :subject_semester
  alias_attribute :year,     :subject_year
  alias_attribute :brs,      :subject_brs

  belongs_to :group, foreign_key: :subject_group

  belongs_to :lead_teacher, class_name: User, foreign_key: :subject_teacher

  has_many :discipline_teachers, class_name: Study::DisciplineTeacher,
           primary_key: :subject_id, foreign_key: :subject_id, dependent: :destroy
  accepts_nested_attributes_for :discipline_teachers, allow_destroy: true,
                                reject_if: proc { |attrs| attrs[:teacher_id].blank? }

  has_many :assistant_teachers, through: :discipline_teachers

  [[:lectures, Study::Checkpoint::TYPE_LECTURE], [:seminars, Study::Checkpoint::TYPE_SEMINAR],
   [:checkpoints, Study::Checkpoint::TYPE_CHECKPOINT]].each do |lessons|
    has_many lessons[0], -> { where(checkpoint_type: lessons[1]).order(:checkpoint_date) },
             class_name: Study::Checkpoint, foreign_key: :checkpoint_subject, dependent: :destroy
    accepts_nested_attributes_for lessons[0], allow_destroy: true
  end

  has_many :classes, -> { order(:checkpoint_date) }, class_name: Study::Checkpoint, foreign_key: :checkpoint_subject

  has_many :exams, class_name: Study::Exam, foreign_key: :exam_subject, dependent: :destroy
  accepts_nested_attributes_for :exams, allow_destroy: true

  has_one :validation, -> { where(exam_type: Study::Exam::TYPE_VALIDATION)}, class_name: Study::Exam, foreign_key: :exam_subject, dependent: :destroy

  has_one :final_exam, -> { where(exam_type: Study::Exam::EXAMS_TYPES.collect{|x| x[1]}) }, class_name: Study::Exam, foreign_key: :exam_subject, dependent: :destroy, inverse_of: :discipline
  accepts_nested_attributes_for :final_exam

  has_many :additional_exams, -> { where(exam_type: Study::Exam::ADDITIONAL_EXAMS_TYPES.collect{|x| x[1]}) },
           class_name: 'Study::Exam', foreign_key: :exam_subject, dependent: :destroy
  accepts_nested_attributes_for :additional_exams, allow_destroy: true

  has_one :semester_work, -> { where(exam_type: Study::Exam::TYPE_SEMESTER_WORK)}, 
          class_name: Study::Exam, foreign_key: :exam_subject
  has_one :semester_project, -> { where(exam_type: Study::Exam::TYPE_SEMESTER_PROJECT)}, 
          class_name: Study::Exam, foreign_key: :exam_subject

  belongs_to :department, primary_key: :department_id, foreign_key: :department_id

  validates :name, presence: true
  validates :year, presence: true, numericality: { greater_than: 2010, less_than: 2020 }
  validates :semester, presence: true, inclusion: { in: [1,2] }
  validates :lead_teacher, presence: true
  validates :group, presence: true
  validate  :sum_of_checkpoints_max_values_should_be_80
  validate  :sum_of_checkpoints_min_values_should_be_44

  default_scope do
    order(subject_year: :desc, subject_semester: :desc, subject_name: :asc)
  end

  scope :from_name, -> name { where('subject_name LIKE :prefix', prefix: "#{name}%")}
  scope :from_student, -> student {where(subject_group:  student.group)}
  scope :from_group, -> group {where(subject_group: group)}

  scope :by_term, -> year, term {
    where(subject_year: year, subject_semester: term)
  }

  scope :now, -> { by_term(CURRENT_STUDY_YEAR, CURRENT_STUDY_TERM) }

  scope :include_teacher, -> user {
    if user.is?(:subdepartment_assistant) || user.is?(:subdepartment)
      # Определяем его кафедру.
      dep_ids = user.positions.from_role(['subdepartment_assistant', 'subdepartment']).map { |p| p.department.id }
      users = User.in_department(dep_ids).with_role(Role.select(:acl_role_id).where(acl_role_name: ['lecturer', 'subdepartment']))
      ids = users.map { |u| u.id }.push(user.id)

      includes(:assistant_teachers).references(:assistant_teachers)
      .where('subject_teacher IN (?) OR subject_teacher.teacher_id IN (?)', ids, ids).references(:subject_teacher)
    else
      includes(:assistant_teachers).references(:assistant_teachers)
      .where('subject_teacher = ? OR subject_teacher.teacher_id = ?', user.id, user.id).references(:subject_teacher)
    end
  }

  scope :with_brs, ->{where(subject_brs:  true)}

  def students
    if is_active? && semester == CURRENT_STUDY_TERM
      group.students.valid_for_today
    else
      Student.in_group_at_date(group, Date.new((autumn? ? year : year + 1), (autumn? ? 11 : 5), 15))
    end
  end

  # Список студентов, которые потенциально могут пересдавать эту дисциплину.
  def students_for_repeat
    Student.my_filter(
      status: Student::STATUS_TRANSFERRED_DEBTOR,
      speciality: group.speciality.id,
      course: group.course + 1
    )
  end

  def has?(type)
    work = (type == 'work' ? 2 : 3)
    exams.where(exam_type: work) != []
  end

  def autumn?
    semester == 1
  end

  def control
    exams.where(exam_type: [0,1,9]).first
  end

  def lecture_weight
    lectures.empty? ? 0 : (seminars.count > 0 ? 5.0 : 20.0)/lectures.count
  end

  def seminar_weight
    seminars.empty? ? 0 : (lectures.count > 0 ? 15.0 : 20.0)/seminars.count
  end

  def current_ball
  lessons = [lectures.not_future.count*lecture_weight,
   seminars.not_future.count*seminar_weight,
   checkpoints.not_future.collect { |c| c.max }.sum].sum.round(2)
  end

  def is_active?
    year == CURRENT_STUDY_YEAR
    #case CURRENT_STUDY_TERM
    #  when 1
    #    year == CURRENT_STUDY_YEAR || (year == CURRENT_STUDY_YEAR - 1 && semester == 2)
    #  when 2
    #    year == CURRENT_STUDY_YEAR
    #end
  end

  def brs?
    classes.any? && subject_brs
  end

  def not_brs?
    classes.empty? && !subject_brs
  end

  def add_semester_work
    exams.create(exam_type: Study::Exam::TYPE_SEMESTER_WORK)
    save!
  end
  def add_semester_project
    exams.create(exam_type: Study::Exam::TYPE_SEMESTER_PROJECT)
  end

  def destroy_semester_work
    semester_work.destroy
    save!
  end
  def destroy_semester_project
    semester_project.destroy
    save!
  end

  private

  def sum_of_checkpoints_max_values_should_be_80
    return true if checkpoints.length == 0
    max_sum = 0
    checkpoints.each do |c|
      return false if c.max.nil?
      max_sum += c.max unless c.marked_for_destruction?
    end
    if 80 != max_sum
      errors.add(:'checkpoints.max',
                 "Сумма максимальных баллов должна равняться 80. У вас — #{max_sum}.")
    end
  end

  def sum_of_checkpoints_min_values_should_be_44
    return true if checkpoints.length == 0
    min_sum = 0
    checkpoints.each do |c|
      return false if c.min.nil?
      min_sum += c.min unless c.marked_for_destruction?
    end
    if 44 != min_sum
      errors.add(:'checkpoints.min',
                 "Сумма минимальных зачётных баллов должна равняться 44. У вас — #{min_sum}.")
    end
  end
end
