class CreateHostelReportOffenseRoom < ActiveRecord::Migration
  def change
    create_table :hostel_report_offense_room do |t|
      t.references :hostel_report_offense, index: true
      t.references :room, index: true
    end
  end
end
