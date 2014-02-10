class GraduateSubject < ActiveRecord::Base
  TYPE_SUBJECT  = 1
  TYPE_PAPER    = 2

  belongs_to :graduate

  has_many :graduate_students
  has_many :graduate_marks

  scope :only_subjects, -> { where(kind: TYPE_SUBJECT) }
  scope :only_papers, -> { where(kind: TYPE_PAPER) }

  def text_kind
    case kind
      when TYPE_SUBJECT
        'дисициплина'
      when TYPE_PAPER
        'курсовая'
    end
  end
end
