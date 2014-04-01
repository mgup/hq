class Hostel::Offense < ActiveRecord::Base
  TYPE_DEFAULT = 1
  TYPE_ROOM = 2
  TYPE_STUDENT = 3
  self.table_name = 'hostel_offense'

  has_many :report_offenses, class_name: Hostel::ReportOffense, foreign_key: :hostel_offense_id
  has_many :reports, class_name: Hostel::Report, through: :report_offenses

  def type
    case kind
      when TYPE_DEFAULT
        'общее'
      when TYPE_ROOM
        'комнаты'
      when TYPE_STUDENT
        'студенты'
    end
  end

  def type_room?
    TYPE_ROOM == kind
  end

  def type_student?
    TYPE_STUDENT == kind
  end
end