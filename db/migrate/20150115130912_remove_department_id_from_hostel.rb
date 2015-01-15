class RemoveDepartmentIdFromHostel < ActiveRecord::Migration
  def change
    change_table :hostel do |t|
      t.remove :department_id
    end
  end
end
