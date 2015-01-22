class Hostel::OffenseStudent < ActiveRecord::Base
  self.table_name = 'hostel_report_offense_student'

  belongs_to :offense, class_name: Hostel::ReportOffense, foreign_key: :hostel_offense_id
  belongs_to :person, class_name: Person, primary_key: :student_id, foreign_key: :student_id

end