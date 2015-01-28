class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.text :name
      t.timestamps
    end
  end
end
