class CreateActivityType < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
