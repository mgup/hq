class CreateActivityGroup < ActiveRecord::Migration
  def change
    create_table :activity_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
