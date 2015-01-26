class CreateCompetitiveGroupItems < ActiveRecord::Migration
  def change
    create_table :competitive_group_items do |t|
      t.references :competitive_group, null: false

      t.references :education_level, null: false
      t.references :direction, null: false #Справочник №10

      t.integer :number_budget_o
      t.integer :number_budget_oz
      t.integer :number_budget_z
      t.integer :number_paid_o
      t.integer :number_paid_oz
      t.integer :number_paid_z
      t.integer :number_quota_o
      t.integer :number_quota_oz
      t.integer :number_quota_z
    end
  end
end
