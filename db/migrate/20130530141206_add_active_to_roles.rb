class AddActiveToRoles < ActiveRecord::Migration
  def change
    change_table :acl_role do |t|
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
