class Study::Checkpoint < ActiveRecord::Base
  self.table_name = 'checkpoint'

  TYPE_LECTURE = 1
  TYPE_PRACTICAL = 2
  TYPE_CHECKPOINT = 3

  alias_attribute :id,       :checkpoint_id
  alias_attribute :name,     :checkpoint_name
  alias_attribute :type,     :checkpoint_type
  alias_attribute :details,  :checkpoint_details
  alias_attribute :date,     :checkpoint_date
  alias_attribute :min,      :checkpoint_min
  alias_attribute :max,      :checkpoint_max
  alias_attribute :closed,   :checkpoint_closed

  belongs_to :discipline, class_name: Study::Discipline, foreign_key: :checkpoint_subject

  has_many :checkpointmarks, class_name: Study::Checkpointmark, foreign_key: :checkpoint_mark_checkpoint

  scope :by_discipline, -> discipline { where(checkpoint_subject: discipline) }
  scope :control, -> {where(checkpoint_type: 3 )}

  def lesson
    case type
      when TYPE_LECTURE
        'glyphicon-headphones'
      when TYPE_PRACTICAL
        'glyphicon-file'
      when TYPE_CHECKPOINT
        'glyphicon-bell'
    end
  end

  def lessonname
    case type
      when TYPE_LECTURE
        'Лекция'
      when TYPE_PRACTICAL
        'Практическое (лабораторное) занятие'
    end
  end

  def lecture?
    TYPE_LECTURE == type
  end

  def seminar?
    TYPE_PRACTICAL == type
  end

  def check?
    TYPE_CHECKPOINT == type
  end


end