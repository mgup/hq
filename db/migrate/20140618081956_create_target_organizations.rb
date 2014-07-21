class CreateTargetOrganizations < ActiveRecord::Migration
  def change
    create_table :target_organizations do |t|
      t.references :competitive_group, null: false
      t.string :name
      t.timestamps
    end
  end
end
