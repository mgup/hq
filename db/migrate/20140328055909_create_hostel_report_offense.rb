class CreateHostelReportOffense < ActiveRecord::Migration
  def change
    create_table :hostel_report_offense do |t|
      t.references :hostel_report, index: true
      t.references :hostel_offense, index: true
    end
  end
end
