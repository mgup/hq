class AddDepartmentIdToHostel < ActiveRecord::Migration
  def change
    change_table :hostel do |t|
      t.belongs_to :department
    end
  end
end
