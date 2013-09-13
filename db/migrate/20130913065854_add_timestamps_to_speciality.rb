class AddTimestampsToSpeciality < ActiveRecord::Migration
  def change
    change_table :speciality do |t|
      t.timestamps
    end
  end
end
