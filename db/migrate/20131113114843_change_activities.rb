class ChangeActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.boolean :active, default: true
      t.boolean :unique, default: true
      t.boolean :placeholder
      t.integer :base, default: 1
      t.decimal :credit, precision: 5, scale: 1
    end
  end
end
