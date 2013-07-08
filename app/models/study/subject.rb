class Study::Subject < ActiveRecord::Base
  self.table_name = 'study_subjects'

  TYPE_TEST = 0
  TYPE_EXAM = 1
  TYPE_KURS_RAB = 2

  belongs_to :group
  belongs_to :user

  has_many :marks, class_name: Study::Mark

  validates_presence_of :year, :semester, :title, :kind

  scope :find_subjects, -> subject {where(year: subject.year, 
                      semester: subject.semester, group_id: subject.group_id, 
                      title: subject.title, kind: subject.kind)}

  def type
    case kind
      when TYPE_TEST
        'зачёт'
      when TYPE_EXAM
        'экзамен'
      when TYPE_KURS_RAB
        'курсовая работа'
    end
  end

  def test?
    TYPE_TEST == kind
  end

  def exam?
    TYPE_EXAM == kind
  end

  def curs_rab?
    TYPE_KURS_RAB == kind
  end

  def in_fall?
    1 == semester
  end

  def in_spring?
    2 == semester
  end
end