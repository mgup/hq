class CreateHostelReportApplication < ActiveRecord::Migration
  def change
    create_table :hostel_report_application do |t|
      t.string        :name
      t.integer       :papers
      t.references :hostel_report, index: true
    end
  end
end
