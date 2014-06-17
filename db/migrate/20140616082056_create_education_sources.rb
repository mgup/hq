class CreateEducationSources < ActiveRecord::Migration
  def change
    create_table :education_sources do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
