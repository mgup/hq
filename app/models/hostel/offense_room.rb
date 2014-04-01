class Hostel::OffenseRoom < ActiveRecord::Base
  self.table_name = 'hostel_report_offense_room'

  belongs_to :offense, class_name: Hostel::ReportOffense, foreign_key: :hostel_offense_id
  belongs_to :room, class_name: Hostel::Room, primary_key: :room_id, foreign_key: :room_id

end
