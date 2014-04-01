class CreateHostelReportOffenseStudent < ActiveRecord::Migration
  def change
    create_table :hostel_report_offense_student do |t|
      t.references :hostel_report_offense, index: true
      t.references :student, index: true
    end
  end
end
