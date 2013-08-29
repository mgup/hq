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

  belongs_to :discipline, -> { where(checkpoint_type: Study::Checkpoint::TYPE_CHECKPOINT).order(:checkpoint_date) },
             class_name: Study::Discipline, foreign_key: :checkpoint_subject, inverse_of: :checkpoints

  has_many :checkpointmarks, class_name: Study::Checkpointmark, foreign_key: :checkpoint_mark_checkpoint

  validates :name, presence: true
  validates :max,  presence: true, numericality: { greater_than: 0 }
  validates :min,  presence: true, numericality: { greater_than: 0 }
  validate  :min_should_be_less_than_max

  scope :by_discipline, -> discipline { where(checkpoint_subject: discipline) }
  scope :by_date, -> date {where(checkpoint_date: date)}
  scope :control, -> {where(checkpoint_type: TYPE_CHECKPOINT )}
  scope :lectures, -> {where(checkpoint_type: TYPE_LECTURE )}
  scope :practicals, -> {where(checkpoint_type: TYPE_SEMINAR)}

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

  def check?
    TYPE_CHECKPOINT == type
  end

  private

  def min_should_be_less_than_max
    if !marked_for_destruction? && min >= max
      errors.add(:'minmax',
                 'Минимальный зачётный балл должен быть меньше, чем максимальный балл.')
    end
  end
end