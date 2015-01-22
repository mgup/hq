class CreateEventCategoryTable < ActiveRecord::Migration
  def change
    create_table :event_category do |t|
      t.string        :name, null: false
      t.text          :description, null: false
      t.timestamps
    end
  end
end
