class Study::Checkpointmark < ActiveRecord::Base
  self.table_name = 'checkpoint_mark'

  MARK_LECTURE_NOT_ATTEND   = 1001
  MARK_LECTURE_ATTEND       = 1002

  MARK_PRACTICAL_BAD        = 2001
  MARK_PRACTICAL_FAIR       = 2002
  MARK_PRACTICAL_GOOD       = 2003
  MARK_PRACTICAL_PERFECT    = 2004

  alias_attribute :id,        :checkpoint_mark_id
  alias_attribute :mark,      :checkpoint_mark_mark
  alias_attribute :retake,    :checkpoint_mark_retake

  belongs_to :student, primary_key: :id, foreign_key: :checkpoint_mark_student
  belongs_to :checkpoint, class_name: Study::Checkpoint, primary_key: :id, foreign_key: :checkpoint_mark_checkpoint

  scope :by_checkpoint, -> checkpoint { where(checkpoint: checkpoint) }
  scope :by_student, -> student { where(student: student) }

  def result
    case mark
      when MARK_LECTURE_NOT_ATTEND
        'не посетил'
      when MARK_LECTURE_ATTEND
        'посетил'
      when MARK_PRACTICAL_BAD
        'неудовлетворительно'
      when MARK_PRACTICAL_FAIR
        'удовлетворительно'
      when MARK_PRACTICAL_GOOD 
        'хорошо'
      when MARK_PRACTICAL_PERFECT
        'отлично'
    end
  end

  def result_color
    case mark
      when MARK_LECTURE_NOT_ATTEND
        'danger'
      when MARK_LECTURE_ATTEND
        'success'
      when MARK_PRACTICAL_BAD
        'danger'
      when MARK_PRACTICAL_FAIR
        'warning'
      when MARK_PRACTICAL_GOOD 
        'success'
      when MARK_PRACTICAL_PERFECT
        'success'
    end
  end

end