class AddDescriptionToRole < ActiveRecord::Migration
  def change
    change_table :acl_role do |t|
      t.text :description, null: true
    end
  end
end
