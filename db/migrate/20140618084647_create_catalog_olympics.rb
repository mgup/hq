class CreateCatalogOlympics < ActiveRecord::Migration
  def change
    create_table :use_olympics do |t|
      t.string :name
      t.integer :number

      t.timestamps

      #TODO связь с subjects (subject_id (видимо, справочник 1?), level_id (???))
    end
  end
end
