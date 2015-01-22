class AddStatusFieldToHostelReport < ActiveRecord::Migration
  def change
    add_column :hostel_report, :status, :integer
  end
end
