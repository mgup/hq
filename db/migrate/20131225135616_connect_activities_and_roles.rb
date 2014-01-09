class ConnectActivitiesAndRoles < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.integer :role_id, index: true
    end
  end
end
