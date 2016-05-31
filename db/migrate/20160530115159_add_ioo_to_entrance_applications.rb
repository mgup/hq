class AddIooToEntranceApplications < ActiveRecord::Migration
  def change
    change_table :entrance_applications do |t|
      t.boolean :ioo, default: false
    end
  end
end
