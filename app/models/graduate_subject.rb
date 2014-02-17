class GraduateSubject < ActiveRecord::Base
  TYPE_SUBJECT  = 1
  TYPE_PAPER    = 2

  TYPE_WORK3  = 3   # Научно-исследовательская практика
  TYPE_WORK4  = 4   # Научно-производственная практика
  TYPE_WORK5  = 5   # Педагогическая практика
  TYPE_WORK6  = 6   # Преддипломная практика
  TYPE_WORK7  = 7   # Производственная практика
  TYPE_WORK8  = 8   # Производственная практика (пленэр)
  TYPE_WORK9  = 9   # Производственно-технологическая практика
  TYPE_WORK10 = 10  # Технологическая практика
  TYPE_WORK11 = 11  # Научно-исследовательская работа
  TYPE_WORK12 = 12  # Учебная ознакомительная практика
  TYPE_WORK13 = 13  # Учебная практика
  TYPE_WORK14 = 14  # Учебная практика (мастерство)
  TYPE_WORK15 = 15  # Учебная художественно-технологическая практика

  belongs_to :graduate

  has_many :graduate_students
  has_many :graduate_marks, dependent: :destroy

  scope :only_subjects, -> { where(kind: TYPE_SUBJECT) }
  scope :only_papers, -> { where(kind: TYPE_PAPER) }
  scope :only_works, -> { where('kind NOT IN (?)', [TYPE_SUBJECT, TYPE_PAPER]) }

  def text_kind
    case kind
      when TYPE_SUBJECT
        'дисициплина'
      when TYPE_PAPER
        'курсовая'
      when TYPE_WORK3
        'научно-исследовательская практика'
      when TYPE_WORK4
        'научно-производственная практика'
      when TYPE_WORK5
        'педагогическая практика'
      when TYPE_WORK6
        'преддипломная практика'
      when TYPE_WORK7
        'производственная практика'
      when TYPE_WORK8
        'производственная практика (пленэр)'
      when TYPE_WORK9
        'производственно-технологическая практика'
      when TYPE_WORK10
        'технологическая практика'
      when TYPE_WORK11
        'научно-исследовательская работа'
      when TYPE_WORK12
        'учебная ознакомительная практика'
      when TYPE_WORK13
        'учебная практика'
      when TYPE_WORK14
        'учебная практика (мастерство)'
      when TYPE_WORK15
        'учебная художественно-технологическая практика'
    end
  end
end
