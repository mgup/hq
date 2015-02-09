class Study::Checkpoint < ActiveRecord::Base
  self.table_name = 'checkpoint'

  TYPE_LECTURE = 1
  TYPE_SEMINAR = 2
  TYPE_CHECKPOINT = 3

  alias_attribute :id,       :checkpoint_id
  alias_attribute :name,     :checkpoint_name
  alias_attribute :type,     :checkpoint_type
  alias_attribute :details,  :checkpoint_details
  alias_attribute :date,     :checkpoint_date
  alias_attribute :min,      :checkpoint_min
  alias_attribute :max,      :checkpoint_max
  alias_attribute :closed,   :checkpoint_closed

  #belongs_to :discipline, -> { where(checkpoint_type: Study::Checkpoint::TYPE_CHECKPOINT).order(:checkpoint_date) },
  #           class_name: Study::Discipline, foreign_key: :checkpoint_subject, inverse_of: :checkpoints
  belongs_to :discipline, class_name: Study::Discipline, foreign_key: :checkpoint_subject, inverse_of: :checkpoints

  has_many :marks, class_name: Study::Mark, foreign_key: :checkpoint_mark_checkpoint
  accepts_nested_attributes_for :marks, allow_destroy: true, reject_if: proc { |attrs| attrs[:mark].blank? }

  validates :name, presence: true, if: -> c { Study::Checkpoint::TYPE_CHECKPOINT == c.type }
  [:max, :min].each do |m|
    validates m,  presence: true, numericality: { greater_than: 0 }, if: -> c { Study::Checkpoint::TYPE_CHECKPOINT == c.type }
  end

  #validates :max,  presence: true, numericality: { greater_than: 0 }, if: -> c { Study::Checkpoint::TYPE_CHECKPOINT == c.type }
  #validates :min,  presence: true, numericality: { greater_than: 0 }, if: -> c { Study::Checkpoint::TYPE_CHECKPOINT == c.type }
  validate  :min_should_be_less_than_max, if: -> c { Study::Checkpoint::TYPE_CHECKPOINT == c.type }
  #validate  :mark_should_be_less_than_max, if: -> c { Study::Checkpoint::TYPE_CHECKPOINT == c.type }

  scope :by_discipline, -> discipline { where(checkpoint_subject: discipline) }
  scope :by_date, -> date {where(checkpoint_date: date)}
  scope :control, -> {where(checkpoint_type: TYPE_CHECKPOINT )}
  scope :lectures, -> {where(checkpoint_type: TYPE_LECTURE )}
  scope :practicals, -> {where(checkpoint_type: TYPE_SEMINAR)}
  scope :not_future, -> {where("checkpoint_date <= '#{Date.today.strftime('%Y-%m-%d')}'")}
  scope :not_full, -> discipline { where("checkpoint_subject = #{discipline.id} AND checkpoint_date < '#{Date.today.strftime('%Y-%m-%d')}' AND
        (SELECT COUNT(DISTINCT checkpoint_mark_student)
        FROM checkpoint_mark JOIN student_group ON student_group_id = checkpoint_mark_student
        WHERE checkpoint_mark_checkpoint = checkpoint_id
        AND student_group_id IN (#{discipline.year == Study::Discipline::CURRENT_STUDY_YEAR && discipline.semester == Study::Discipline::CURRENT_STUDY_TERM ? discipline.group.students.valid_for_today.collect{|s| s.id}.join(',') : Student.in_group_at_date(discipline.group.id, Date.new((discipline.autumn? ? discipline.year : discipline.year+1), (discipline.autumn? ? 11 : 5), 15)).collect{|s| s.id}.join(',')})) <
        (SELECT COUNT(*) FROM student_group
        WHERE student_group_id IN (#{discipline.year == Study::Discipline::CURRENT_STUDY_YEAR && discipline.semester == Study::Discipline::CURRENT_STUDY_TERM ? discipline.group.students.valid_for_today.collect{|s| s.id}.join(',') : Student.in_group_at_date(discipline.group.id, Date.new((discipline.autumn? ? discipline.year : discipline.year+1), (discipline.autumn? ? 11 : 5), 15)).collect{|s| s.id}.join(',')}))")}
  scope :not_full_final, -> discipline { where("checkpoint_subject = #{discipline.id} AND
        (SELECT COUNT(DISTINCT checkpoint_mark_student)
        FROM checkpoint_mark JOIN student_group ON student_group_id = checkpoint_mark_student
        WHERE checkpoint_mark_checkpoint = checkpoint_id
        AND student_group_id IN (#{discipline.year == Study::Discipline::CURRENT_STUDY_YEAR && discipline.semester == Study::Discipline::CURRENT_STUDY_TERM ? discipline.group.students.valid_for_today.collect{|s| s.id}.join(',') : Student.in_group_at_date(discipline.group.id, Date.new((discipline.autumn? ? discipline.year : discipline.year+1), (discipline.autumn? ? 11 : 4), 15)).collect{|s| s.id}.join(',')})) <
        (SELECT COUNT(*) FROM student_group
        WHERE student_group_id IN (#{discipline.year == Study::Discipline::CURRENT_STUDY_YEAR && discipline.semester == Study::Discipline::CURRENT_STUDY_TERM ? discipline.group.students.valid_for_today.collect{|s| s.id}.join(',') : Student.in_group_at_date(discipline.group.id, Date.new((discipline.autumn? ? discipline.year : discipline.year+1), (discipline.autumn? ? 11 : 4), 15)).collect{|s| s.id}.join(',')}))") }

  def lesson
    case type
      when TYPE_LECTURE
        'glyphicon-headphones'
      when TYPE_SEMINAR
        'glyphicon-file'
      when TYPE_CHECKPOINT
        'glyphicon-bell'
    end
  end

  def lessonname
    case type
      when TYPE_LECTURE
        'Лекция'
      when TYPE_SEMINAR
        'Практическое (лабораторное) занятие'
    end
  end

  def lecture?
    TYPE_LECTURE == type
  end

  def seminar?
    TYPE_SEMINAR == type
  end

  def is_checkpoint?
    TYPE_CHECKPOINT == type
  end

  private

  def min_should_be_less_than_max
    if !min.nil? && !max.nil?
      if !marked_for_destruction? && min >= max
        errors.add(:'minmax',
                 'Минимальный зачётный балл должен быть меньше, чем максимальный балл.')
      end
    end
  end

  def mark_should_be_less_than_max
    marks.each do |m|
      if !min.nil? && !max.nil?
        if m.mark > max or m.mark < 0
          errors.add("#{m.id}",
                   'Балл за контрольную точку должен быть меньше, чем максимальный балл, и больше 0.')
        end
      end
    end
  end
end