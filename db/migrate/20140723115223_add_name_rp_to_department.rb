class AddNameRpToDepartment < ActiveRecord::Migration
  def change
    change_table :department do |t|
      t.string :name_rp
      t.string :short_name_rp
    end
  end
end
