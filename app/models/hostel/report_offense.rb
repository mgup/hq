class Hostel::ReportOffense < ActiveRecord::Base
  self.table_name = 'hostel_report_offense'

  belongs_to :report, class_name: Hostel::Report, foreign_key: :hostel_report_id
  belongs_to :offense,class_name: Hostel::Offense, foreign_key: :hostel_offense_id

  has_many :offense_rooms, class_name: Hostel::OffenseRoom, foreign_key: :hostel_report_offense_id, dependent: :destroy
  accepts_nested_attributes_for :offense_rooms, allow_destroy: true
  has_many :rooms, class_name: Hostel::Room, through: :offense_rooms

  has_many :offense_students, class_name: Hostel::OffenseStudent, foreign_key: :hostel_report_offense_id, dependent: :destroy
  accepts_nested_attributes_for :offense_students, allow_destroy: true
  has_many :persons, class_name: Person, through: :offense_students
end