class Hostel::ReportApplication < ActiveRecord::Base
  self.table_name = 'hostel_report_application'

  belongs_to :report, class_name: Hostel::Report, foreign_key: :hostel_report_id

end