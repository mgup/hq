class AddDepartmentToDirection < ActiveRecord::Migration
  def change
    change_table :directions do |t|
      t.belongs_to :department
    end
  end
end
