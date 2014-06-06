class Study::Subject < ActiveRecord::Base
  self.table_name = 'study_subjects'

  TYPE_TEST = 0
  TYPE_EXAM = 1
  TYPE_KURS_RAB = 2
  TYPE_KURS_PRJ = 3
  TYPE_PR = 4
  TYPE_DIP_PR = 5
  TYPE_GAK = 6
  TYPE_GRAD_TEST = 9

  belongs_to :group
  belongs_to :user

  validates_presence_of :year, :semester, :title, :kind

  scope :find_subjects, -> subject {where(year: subject.year, 
                      semester: subject.semester, group_id: subject.group_id, 
                      title: subject.title, kind: subject.kind)}
  scope :from_group, -> group {group == '' ? all : where(group_id:  group)}
  scope :from_name, -> name { where("title LIKE :prefix", prefix: "#{name}%")}

  def type
    case kind
      when TYPE_TEST
        'зачёт'
      when TYPE_EXAM
        'экзамен'
      when TYPE_KURS_RAB
        'курсовая работа'
        when TYPE_KURS_PRJ
        'курсовой проект'
        when TYPE_PR
        'практика'
        when TYPE_DIP_PR
        'преддипломная практика'
        when TYPE_GAK
        'ГАК'
        when TYPE_GRAD_TEST
        'дифференцированный зачёт'
    end
  end

  def term
    case semester
      when 1
        'осенний семестр'
      when 2
        'весенний семестр'
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