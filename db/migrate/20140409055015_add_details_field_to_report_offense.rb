class AddDetailsFieldToReportOffense < ActiveRecord::Migration
  def change
    add_column :hostel_report_offense, :details, :text
  end
end
