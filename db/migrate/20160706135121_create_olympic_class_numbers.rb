class CreateOlympicClassNumbers < ActiveRecord::Migration
  def change
    create_table :olympic_class_numbers do |t|
      t.string     :name
    end
  end
end
