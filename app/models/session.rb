class Session < ActiveRecord::Base
  TYPE_TEST = 0
  TYPE_EXAM = 1

  belongs_to :group
  belongs_to :user

  has_many :session_marks

  validates_presence_of :year, :semester, :subject, :kind

  def type
    case kind
      when TYPE_TEST
        'зачёт'
      when TYPE_EXAM
        'экзамен'
    end
  end

  def test?
    TYPE_TEST == kind
  end

  def exam?
    TYPE_EXAM == kind
  end
end